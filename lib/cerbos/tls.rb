# frozen_string_literal: true

module Cerbos
  # Settings for encrypting the gRPC connection with TLS.
  class TLS
    # @return [String, nil] the PEM-encoded certificates of root certificate authorities used to verify the server certificate.
    attr_reader :root_certificates_pem

    # Create settings for encrypting the gRPC connection with TLS.
    #
    # @param root_certificates_pem [String, nil] the PEM-encoded certificates of root certificate authorities used to verify the server certificate (`nil` to use the public roots bundled with the `grpc` gem).
    def initialize(root_certificates_pem: nil)
      @root_certificates_pem = root_certificates_pem
    end

    # @private
    def to_channel_credentials
      GRPC::Core::ChannelCredentials.new(root_certificates_pem)
    end
  end
end
