# frozen_string_literal: true

RSpec.describe Cerbos::Hub::AccessToken do
  subject(:access_token) { described_class.new(client_id:, client_secret:, target: "localhost:#{port}", credentials: :this_channel_is_insecure, grpc_channel_args: {}, grpc_metadata:, timeout: nil) }

  let(:server) { StubServer.new }
  let(:service) { server.api_key_service }
  let(:port) { server.port }
  let(:client_id) { "KT8DGHXEZIK2" }
  let(:client_secret) { "correct-horse-battery-staple" }
  let(:grpc_metadata) { {foo: "42"} }
  let(:request) { Cerbos::Protobuf::Cerbos::Cloud::Apikey::V1::IssueAccessTokenRequest.new(client_id:, client_secret:) }
  let(:token) { "let-me-in" }
  let(:expires_in) { 60 * 60 }
  let(:success) { {access_token: token, expires_in: {seconds: expires_in}} }

  before do
    allow(service).to receive(:issue_access_token).with(request, anything) do
      response = responses.shift
      raise "unexpected request" if response.nil?
      raise response if response.is_a?(StandardError)

      Cerbos::Protobuf::Cerbos::Cloud::Apikey::V1::IssueAccessTokenResponse.new(**response)
    end

    server.start
  end

  after do
    server.stop
  end

  describe "#fetch" do
    context "when successful" do
      let(:responses) { [success] }

      it "memoizes tokens" do
        tokens = 5.times.map { Concurrent::Promises.future { access_token.fetch } }.map(&:value!)
        expect(tokens).to eq(Array.new(5, token))

        tokens = 5.times.map { Concurrent::Promises.future { access_token.fetch } }.map(&:value!)
        expect(tokens).to eq(Array.new(5, token))

        expect(service).to have_received(:issue_access_token).once
      end

      it "sets metadata on requests" do
        access_token.fetch

        expect(service).to have_received(:issue_access_token) do |_, call|
          expect(call.metadata).to match({
            "foo" => "42",
            "user-agent" => a_string_starting_with("cerbos-sdk-ruby/#{Cerbos::VERSION} grpc-ruby/#{GRPC::VERSION} ")
          })
        end
      end
    end

    context "when token is about to expire" do
      let(:responses) { [success, success] }

      current_time = 0

      before do
        allow(Process).to receive(:clock_gettime).and_call_original
        allow(Process).to receive(:clock_gettime).with(Process::CLOCK_MONOTONIC) { current_time }
      end

      it "refreshes" do
        expect(access_token.fetch).to eq(token)

        current_time = expires_in - 300.001

        expect(access_token.fetch).to eq(token)
        expect(service).to have_received(:issue_access_token).once

        current_time = expires_in - 300

        expect(access_token.fetch).to eq(token)
        expect(service).to have_received(:issue_access_token).twice
      end
    end

    context "when errors occur" do
      let(:responses) { [GRPC::Unavailable.new, GRPC::Aborted.new, success] }

      current_time = 0

      before do
        allow(Process).to receive(:clock_gettime).and_call_original
        allow(Process).to receive(:clock_gettime).with(Process::CLOCK_MONOTONIC) { current_time }
      end

      it "backs off" do
        cause = nil
        expect { access_token.fetch }.to raise_error { |error|
          expect(error).to be_a(Cerbos::Error::Unavailable)
          cause = error
        }

        current_time = 0.2

        expect { access_token.fetch }.to raise_error { |error|
          expect(error).to be_a(Cerbos::Error::Cancelled).and(have_attributes(
            cause:,
            details: a_string_starting_with("Previous authentication attempt failed, backing off")
          ))
        }

        current_time = 0.8

        expect { access_token.fetch }.to raise_error(Cerbos::Error::Aborted)

        expect(access_token.fetch).to eq(token)
      end
    end

    context "with bad credentials" do
      let(:responses) { [GRPC::Unauthenticated.new] }

      it "doesn't retry" do
        first_error = nil
        expect { access_token.fetch }.to raise_error { |error|
          expect(error).to be_a(Cerbos::Error::Unauthenticated)
          first_error = error
        }

        expect { access_token.fetch }.to raise_error { |error|
          expect(error).to be(first_error)
        }

        expect(service).to have_received(:issue_access_token).once
      end
    end
  end
end
