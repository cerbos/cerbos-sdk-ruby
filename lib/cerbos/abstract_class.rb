# frozen_string_literal: true

module Cerbos
  # @private
  module AbstractClass
    def initialize
      raise NoMethodError, "Can't initialize #{self.class.name} directly, initialize a subclass instead (#{self.class.subclasses.map(&:name).join(", ")})"
    end
  end
end
