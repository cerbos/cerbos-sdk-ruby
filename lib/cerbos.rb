# frozen_string_literal: true

require "concurrent/atomic/atomic_fixnum"
require "concurrent/atomic/atomic_reference"
require "concurrent/atomic/read_write_lock"
require "google/protobuf"
require "google/protobuf/well_known_types"
require "grpc"
require "securerandom"
require "time"

# Namespace for the `cerbos` gem.
#
# Create a {Client} instance to interact with the Cerbos policy decision point server over gRPC.
module Cerbos
  # @private
  def self.deprecation_warning(message)
    return unless Warning[:deprecated]

    message = "[cerbos] #{message}"

    location = caller_locations.find { |location| !location.absolute_path.start_with?(__dir__) }
    message = "#{location.path}:#{location.lineno}: #{message}" unless location.nil?

    warn message, category: :deprecated
  end
end

require_relative "cerbos/abstract_class"
require_relative "cerbos/protobuf"
require_relative "cerbos/service"
require_relative "cerbos/client"
require_relative "cerbos/input"
require_relative "cerbos/error"
require_relative "cerbos/output"
require_relative "cerbos/hub"
require_relative "cerbos/tls"
require_relative "cerbos/mutual_tls"
require_relative "cerbos/version"
