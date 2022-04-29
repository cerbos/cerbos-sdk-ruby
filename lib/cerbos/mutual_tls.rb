# frozen_string_literal: true

module Cerbos
  # Settings for encrypting the gRPC connection and authenticating the client with mutual TLS.
  class MutualTLS < TLS
    # The PEM-encoded client certificate.
    #
    # @return [String]
    attr_reader :client_certificate_pem

    # The PEM-encoded client private key.
    #
    # @return [String]
    attr_reader :client_key_pem

    # Create settings for encrypting the gRPC connection and authenticating the client with mutual TLS.
    #
    # @param client_certificate_pem [String] the PEM-encoded client certificate.
    # @param client_key_pem [String] the PEM-encoded client private key.
    # @param tls_settings [Hash] arguments to pass to {TLS#initialize}.
    def initialize(client_certificate_pem:, client_key_pem:, **tls_settings)
      super(**tls_settings)

      @client_certificate_pem = client_certificate_pem
      @client_key_pem = client_key_pem
    end

    # @private
    def to_channel_credentials
      GRPC::Core::ChannelCredentials.new(root_certificates_pem, client_key_pem, client_certificate_pem)
    end
  end
end
