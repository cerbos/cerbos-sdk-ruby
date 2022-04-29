# frozen_string_literal: true

module Cerbos
  module Input
    # Attributes for a principal or resource.
    class Attributes
      # Specify a principal's or resource's attributes.
      #
      # @param attributes [Hash{Symbol => String, Numeric, Boolean, Array, Hash, nil}] the principal's or resource's attributes.
      def initialize(**attributes)
        @attributes = attributes
      end

      # @return [Hash{Symbol => String, Numeric, Boolean, Array, Hash, nil}] the principal's or resource's attributes.
      def to_hash
        @attributes
      end

      alias_method :to_h, :to_hash

      # @private
      def to_protobuf
        @attributes.transform_values { |value| Google::Protobuf::Value.from_ruby(value) }
      end
    end
  end
end
