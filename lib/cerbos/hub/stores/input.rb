# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      # Namespace for objects passed to {Client} methods.
      module Input
      end
    end
  end
end

require_relative "input/change_details"
require_relative "input/file_filter"
require_relative "input/file_modification_condition"
require_relative "input/file_operation"
require_relative "input/string_match"
