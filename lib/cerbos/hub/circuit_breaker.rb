# frozen_string_literal: true

module Cerbos
  module Hub
    # @private
    def self.with_circuit_breaker(&)
      CIRCUIT_BREAKER.run(&)
    end

    # @private
    class CircuitBreaker
      def initialize(error_rate_threshold: 0.6, volume_threshold: 5, reset_timeout: 60, window_duration: 15, ignore_errors: [
        GRPC::Aborted,
        GRPC::AlreadyExists,
        GRPC::Cancelled,
        GRPC::DeadlineExceeded,
        GRPC::FailedPrecondition
      ])
        @error_rate_threshold = error_rate_threshold
        @volume_threshold = volume_threshold
        @reset_timeout = reset_timeout
        @ignore_errors = ignore_errors
        @counter = Counter.new(window_duration:)
        @state = Concurrent::AtomicReference.new(:closed)
      end

      def run
        start
        yield.tap do
          succeeded
        end
      rescue => error
        failed error
        raise error
      end

      private

      def start
        loop do
          case state = @state.get
          when Numeric
            raise circuit_open if now < state + @reset_timeout
            return if @state.compare_and_set(state, :half_open)

          when :half_open
            return

          when :closed
            succeeded, failed = @counter.stats
            volume = succeeded + failed
            return if volume < @volume_threshold

            error_rate = failed.fdiv(volume)
            return if error_rate < @error_rate_threshold

            @state.compare_and_set(state, now)
            raise circuit_open
          end
        end
      end

      def succeeded
        @counter.add_success
        @state.compare_and_set(:half_open, :closed)
      end

      def failed(error)
        return if @ignore_errors.any? { |ignored_error| error.is_a?(ignored_error) }

        @counter.add_failure
        @state.compare_and_set(:half_open, now)
      end

      def now
        Process.clock_gettime(Process::CLOCK_MONOTONIC, :second)
      end

      def circuit_open
        Error::Cancelled.new(details: "Too many failures")
      end

      # @private
      class Counter
        def initialize(window_duration:)
          @lock = Concurrent::ReadWriteLock.new
          @window_duration = window_duration
          @buckets = []
          @current_bucket = nil
        end

        def add_success
          current_bucket.add_success
        end

        def add_failure
          current_bucket.add_failure
        end

        def stats
          @lock.with_read_lock do
            time = now

            index = 0

            loop do
              return [0, 0] if index == @buckets.size
              break if valid?(@buckets[index], time)

              index += 1
            end

            successes = 0
            failures = 0

            loop do
              bucket = @buckets[index]
              successes += bucket.successes
              failures += bucket.failures

              index += 1
              return [successes, failures] if index == @buckets.size
            end
          end
        end

        private

        def current_bucket
          time = now
          bucket = @lock.with_read_lock { @current_bucket }
          return bucket if bucket&.time == time

          @lock.with_write_lock do
            return @current_bucket if @current_bucket&.time == time

            @current_bucket = Bucket.new(time:)
            @buckets.push @current_bucket
            @buckets.shift until valid?(@buckets.first, time)

            @current_bucket
          end
        end

        def valid?(bucket, time)
          bucket.time >= time - @window_duration
        end

        def now
          Process.clock_gettime(Process::CLOCK_MONOTONIC, :second)
        end

        # @private
        class Bucket
          attr_reader :time

          def initialize(time:)
            @time = time
            @successes = Concurrent::AtomicFixnum.new
            @failures = Concurrent::AtomicFixnum.new
          end

          def add_success
            @successes.increment
          end

          def add_failure
            @failures.increment
          end

          def successes
            @successes.value
          end

          def failures
            @failures.value
          end
        end
      end
    end

    CIRCUIT_BREAKER = CircuitBreaker.new
    private_constant :CIRCUIT_BREAKER
  end
end
