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

            @result = Success.new(
              response: @service.call(:issue_access_token, request, {}),
              attempted_at:
            )
          end
        rescue Error => error
          @result = Failure.new(error:, attempt:, attempted_at:)
        end

        @result.token
      end

      private

      class None
        def token
          nil
        end

        def next_attempt
          1
        end
      end

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

      class Failure
        def initialize(error:, attempt:, attempted_at:)
          @error = error
          @attempt = attempt
          @retry_at = attempted_at + retry_in
        end

        def token
          raise @error if Process.clock_gettime(Process::CLOCK_MONOTONIC) < @retry_at
        end

        def next_attempt
          @attempt + 1
        end

        private

        def retry_in
          case @error
          when Error::Aborted, Error::Cancelled
            Float::INFINITY
          when Error::Unauthenticated
            -Float::INFINITY
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
    end
  end
end
