# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      # Namespace for objects returned by {Client} methods.
      module Output
      end
    end
  end
end

require_relative "output/get_files"
require_relative "output/list_files"
require_relative "output/modify_files"
require_relative "output/replace_files"
