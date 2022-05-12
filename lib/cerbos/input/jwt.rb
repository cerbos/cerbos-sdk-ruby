# frozen_string_literal: true

module Cerbos
  module Input
    # A JSON Web Token to use as an auxiliary data source, which will be verified against the Cerbos policy decision point (PDP) server's configured JSON Web Key Sets (JWKS) unless verification is disabled on the server.
    #
    # @see https://docs.cerbos.dev/cerbos/latest/configuration/auxdata.html#_jwt Configuring the PDP
    class JWT
      # The encoded JWT.
      #
      # @return [String]
      attr_reader :token

      # The ID of the JWKS to be used by the PDP server to verify the JWT.
      #
      # @return [String]
      # @return [nil] if not provided (in which case the PDP server must have only one JWKS configured or verification disabled).
      attr_reader :key_set_id

      # Specify a JWT to use as an auxiliary data source.
      #
      # @param token [String] the encoded JWT.
      # @param key_set_id [String, nil] the ID of the JWKS to be used by the PDP server to verify the JWT. May be set to `nil` if the PDP server only has one JWKS configured or verification disabled.
      def initialize(token:, key_set_id: nil)
        @token = token
        @key_set_id = key_set_id
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Request::V1::AuxData::JWT.new(
          token: token,
          key_set_id: key_set_id
        )
      end
    end
  end
end
