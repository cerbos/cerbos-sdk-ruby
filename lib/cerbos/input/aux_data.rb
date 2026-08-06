# frozen_string_literal: true

module Cerbos
  module Input
    # Auxiliary data sources that can be referenced in policy conditions.
    class AuxData
      # A JSON Web Token (JWT) to use as an auxiliary data source.
      #
      # @return [JWT]
      # @return [nil] if not provided.
      attr_reader :jwt

      # Named JSON Web Tokens (JWTs) to use as auxiliary data sources.
      #
      # @return [Hash{String => JWT}]
      attr_reader :jwts

      # Specify auxiliary data sources.
      #
      # @param jwt [JWT, Hash, nil] a JSON Web Token (JWT) to use as an auxiliary data source (mutually exclusive with `jwts`).
      # @param jwts [Hash{String, Symbol => JWT, Hash}] named JSON Web Tokens (JWTs) to use as auxiliary data sources (mutually exclusive with `jwts`).
      def initialize(jwt: nil, jwts: {})
        @jwt = Input.coerce_optional(jwt, JWT)
        @jwts = Input.coerce_map(jwts, JWT)
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Request::V1::AuxData.new(
          jwt: jwt&.to_protobuf,
          jwts: jwts.transform_values(&:to_protobuf)
        )
      end
    end
  end
end
