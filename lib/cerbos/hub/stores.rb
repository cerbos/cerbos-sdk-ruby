# frozen_string_literal: true

module Cerbos
  module Hub
    # Namespace for interacting with {https://docs.cerbos.dev/cerbos-hub/policy-stores policy stores}.
    module Stores
    end
  end
end

require_relative "stores/client"
require_relative "stores/error"
require_relative "stores/file"
require_relative "stores/input"
require_relative "stores/output"
