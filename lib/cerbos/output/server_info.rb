# frozen_string_literal: true

module Cerbos
  module Output
    # Information about the Cerbos policy decision point (PDP) server.
    ServerInfo = Output.new_class(:built_at, :commit, :version) do
      # @!attribute [r] built_at
      #   The time at which the PDP server binary was built.
      #
      #   @return [Time] the time at which the PDP server binary was built.
      #   @return [nil] if running a custom build of the PDP server that does not report its build time in ISO 8601 format.

      # @!attribute [r] commit
      #   @return [String] the commit SHA from which the PDP server binary was built.

      # @!attribute [r] version
      #   @return [String] the version of the PDP server.

      def self.from_protobuf(server_info)
        built_at = begin
          Time.iso8601(server_info.build_date)
        rescue ArgumentError
          nil
        end

        new(
          built_at: built_at,
          commit: server_info.commit,
          version: server_info.version
        )
      end
    end
  end
end
