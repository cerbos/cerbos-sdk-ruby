# frozen_string_literal: true

module Cerbos
  # Namespace for objects passed to {Client} methods.
  module Input
    # @private
    def self.coerce_required(value, to_class)
      raise ArgumentError, "Value is required" if value.nil?
      return value if value.is_a?(to_class)

      to_class.new(**value)
    rescue ArgumentError, TypeError => error
      raise Error::InvalidArgument.new(details: "Failed to create #{to_class.name} from #{value.inspect}: #{error}")
    end

    # @private
    def self.coerce_optional(value, to_class)
      return nil if value.nil?

      coerce_required(value, to_class)
    end

    # @private
    def self.coerce_array(values, to_class)
      values.map { |value| coerce_required(value, to_class) }
    end
  end
end

require_relative "input/attributes"
require_relative "input/aux_data"
require_relative "input/jwt"
require_relative "input/principal"
require_relative "input/resource"
require_relative "input/resource_check"
require_relative "input/resource_query"
