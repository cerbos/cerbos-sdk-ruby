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

      # The principal's or resource's attributes.
      #
      # @return [Hash{Symbol => String, Numeric, Boolean, Array, Hash, nil}]
      def to_hash
        @attributes
      end

      alias_method :to_h, :to_hash

      # @private
      def to_protobuf
        @attributes.transform_values { |value| Google::Protobuf::Value.from_ruby(deep_stringify_keys(value)) }
      end

      private

      def deep_stringify_keys(object)
        case object
        when Hash
          object.each_with_object({}) { |(key, value), result| result[key.to_s] = deep_stringify_keys(value) }
        when Array
          object.map { |value| deep_stringify_keys(value) }
        else
          object
        end
      end
    end
  end
end
