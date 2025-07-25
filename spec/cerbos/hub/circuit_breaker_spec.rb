# frozen_string_literal: true

RSpec.describe Cerbos::Hub::CircuitBreaker do
  subject(:circuit_breaker) { described_class.new }

  describe "#run" do
    current_time = 0

    before do
      current_time = 0
      allow(Process).to receive(:clock_gettime).and_call_original
      allow(Process).to receive(:clock_gettime).with(Process::CLOCK_MONOTONIC, :second) { current_time }
    end

    it "trips once it reaches the volume threshold" do
      5.times do
        expect_failure
      end

      expect_circuit_open
    end

    it "trips once it reaches the error rate threshold" do
      4.times do
        expect_success
      end

      6.times do
        expect_failure
      end

      expect_circuit_open
    end

    it "resets" do
      5.times do
        expect_failure
      end

      expect_circuit_open

      current_time = 60

      expect_success
      expect_failure
      expect_success
    end

    it "trips immediately if it fails after resetting" do
      5.times do
        expect_failure
      end

      expect_circuit_open

      current_time = 60

      expect_failure
      expect_circuit_open
    end

    it "rotates stats" do
      5.times do
        expect_failure
        current_time += 4
      end

      expect_success
    end

    it "is threadsafe" do
      [0, 60].each do |time|
        current_time = time

        expect_success

        4.times do
          expect_failure
        end

        10.times.map {
          Concurrent::Promises.future do
            expect_circuit_open
          end
        }.each(&:wait!)
      end
    end

    it "ignores configured errors" do
      10.times do
        expect { circuit_breaker.run { raise GRPC::Aborted } }.to raise_error(GRPC::Aborted)
      end
    end

    def expect_success
      expect(circuit_breaker.run { 42 }).to eq(42)
    end

    def expect_failure
      expect { circuit_breaker.run { raise "💥" } }.to raise_error(RuntimeError, "💥")
    end

    def expect_circuit_open
      expect { |block| circuit_breaker.run(&block) }.to not_yield.and raise_error { |error|
        expect(error).to be_a_circuit_open_error
      }
    end

    def be_a_circuit_open_error
      be_a(Cerbos::Error::Cancelled).and have_attributes(details: "Too many failures")
    end
  end
end
