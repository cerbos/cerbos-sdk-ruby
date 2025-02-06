# frozen_string_literal: true

module Cerbos
  module Output
    # Health of a service provided by the Cerbos policy decision point server.
    HealthCheck = Output.new_class(:status) do
      # @!attribute [r] status
      #   The status of the service.
      #
      #   @return [:SERVING] if the server is up and serving requests for the specified service.
      #   @return [:NOT_SERVING] if the server is shutting down.
      #   @return [:DISABLED] if the service is disabled in the server configuration.

      def self.from_protobuf(health_check)
        new(status: health_check.status)
      end
    end
  end
end
