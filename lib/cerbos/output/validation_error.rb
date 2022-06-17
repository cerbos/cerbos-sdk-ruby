# frozen_string_literal: true

module Cerbos
  module Output
    # An error that occurred while validating the principal or resource attributes against a schema.
    ValidationError = Output.new_class(:path, :message, :source) do
      # @!attribute [r] path
      #   The path to the attribute that failed validation.
      #
      #   @return [String]

      # @!attribute [r] message
      #   The error message.
      #
      #   @return [String]

      # @!attribute [r] source
      #   The source of the invalid attributes.
      #
      #   @return [:SOURCE_PRINCIPAL, :SOURCE_RESOURCE]

      def self.from_protobuf(validation_error)
        new(
          path: validation_error.path,
          message: validation_error.message,
          source: validation_error.source
        )
      end

      # Check if the principal's attributes failed schema validation.
      #
      # @return [Boolean]
      def from_principal?
        source == :SOURCE_PRINCIPAL
      end

      # Check if the resource's attributes failed schema validation.
      #
      # @return [Boolean]
      def from_resource?
        source == :SOURCE_RESOURCE
      end
    end
  end
end
