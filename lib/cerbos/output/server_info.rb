# frozen_string_literal: true

module Cerbos
  module Output
    # Information about the Cerbos policy decision point (PDP) server.
    ServerInfo = Output.new_class(:built_at, :commit, :version) do
      # @!attribute [r] built_at
      #   The time at which the PDP server binary was built.
      #
      #   @return [Time]
      #   @return [nil] if running a custom build of the PDP server that does not report its build time in ISO 8601 format.

      # @!attribute [r] commit
      #   The commit SHA from which the PDP server binary was built.
      #
      #   @return [String]

      # @!attribute [r] version
      #   The version of the PDP server.
      #
      #   @return [String]

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
