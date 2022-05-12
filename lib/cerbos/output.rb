# frozen_string_literal: true

module Cerbos
  # Namespace for objects returned by {Client} methods.
  module Output
    # @private
    def self.new_class(*attributes, &block)
      Class.new do
        attributes.each do |attribute|
          attr_reader attribute
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def initialize(#{attributes.map { |attribute| "#{attribute}:" }.join(", ")})
            #{attributes.map { |attribute| "@#{attribute} = #{attribute}" }.join("\n")}
          end

          def ==(other)
            other.instance_of?(self.class) && #{attributes.map { |attribute| "#{attribute} == other.#{attribute}" }.join(" && ")}
          end

          def hash
            [#{attributes.join(", ")}].hash
          end
        RUBY

        alias_method :eql?, :==

        class_exec(&block) if block
      end
    end
  end
end

require_relative "output/check_resources"
require_relative "output/plan_resources"
require_relative "output/server_info"
