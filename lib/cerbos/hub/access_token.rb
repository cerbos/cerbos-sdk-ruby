# frozen_string_literal: true

module Cerbos
  module Hub
    # @private
    class AccessToken
      def initialize(client_id:, client_secret:, **options)
        @client_id = client_id
        @client_secret = client_secret

        @lock = Concurrent::ReadWriteLock.new
        @result = None.new

        @service = Cerbos::Service.new(
          stub: Protobuf::Cerbos::Cloud::Apikey::V1::ApiKeyService::Stub,
          credentials: GRPC::Core::ChannelCredentials.new,
          **options
        )
      end

      def fetch
        token = @lock.with_read_lock { @result.token }
        return token unless token.nil?

        @lock.with_write_lock do
          token = @result.token
          return token unless token.nil?

          attempt = @result.next_attempt
          attempted_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

          Error.handle do
            request = Protobuf::Cerbos::Cloud::Apikey::V1::IssueAccessTokenRequest.new(
              client_id: @client_id,
              client_secret: @client_secret
            )

            response = Hub.with_circuit_breaker { @service.call(:issue_access_token, request, {}) }

            @result = Success.new(response:, attempted_at:)
          end

          @result.token
        rescue Error => error
          @result = Failure.new(error:, attempt:, attempted_at:)
          raise
        end
      end

      private

      # @private
      class None
        def token
          nil
        end

        def next_attempt
          1
        end
      end
      private_constant :None

      # @private
      class Success
        def initialize(response:, attempted_at:)
          @token = response.access_token
          @refresh_at = attempted_at + response.expires_in.seconds - 300
        end

        def token
          @token if Process.clock_gettime(Process::CLOCK_MONOTONIC) < @refresh_at
        end

        def next_attempt
          1
        end
      end
      private_constant :Success

      # @private
      class Failure
        def initialize(error:, attempt:, attempted_at:)
          @error = error
          @attempt = attempt
          @retry_at = attempted_at + retry_in
        end

        def token
          remaining = @retry_at - Process.clock_gettime(Process::CLOCK_MONOTONIC)
          return nil if remaining <= 0
          raise @error if remaining.infinite?

          begin
            raise @error
          rescue
            raise Error::Cancelled.new(details: "Previous authentication attempt failed, backing off for %.3gs" % remaining)
          end
        end

        def next_attempt
          @attempt + 1
        end

        private

        def retry_in
          case @error
          when Error::Aborted, Error::Cancelled
            -Float::INFINITY # immediately
          when Error::Unauthenticated
            Float::INFINITY # never
          else
            backoff
          end
        end

        MIN_INTERVAL = 0.5
        MAX_INTERVAL = 60
        MULTIPLIER = 1.5
        RANDOMIZATION_FACTOR = 0.5
        USE_MAX_INTERVAL_AFTER_ATTEMPT = (Math.log(MAX_INTERVAL / MIN_INTERVAL) / Math.log(MULTIPLIER)).ceil

        def backoff
          interval = if @attempt > USE_MAX_INTERVAL_AFTER_ATTEMPT
            MAX_INTERVAL
          else
            MULTIPLIER**(@attempt - 1) * MIN_INTERVAL
          end

          interval * (1 + (2 * rand - 1) * RANDOMIZATION_FACTOR)
        end
      end
      private_constant :Failure
    end
  end
end
