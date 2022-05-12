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

      # Specify auxiliary data sources.
      #
      # @param jwt [JWT, Hash, nil] a JSON Web Token (JWT) to use as an auxiliary data source.
      def initialize(jwt: nil)
        @jwt = Input.coerce_optional(jwt, JWT)
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Request::V1::AuxData.new(jwt: jwt&.to_protobuf)
      end
    end
  end
end
