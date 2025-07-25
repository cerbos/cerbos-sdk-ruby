# frozen_string_literal: true

module Cerbos
  module Hub
    # @private
    class Service
      def initialize(client_id:, client_secret:, stub:, credentials: GRPC::Core::ChannelCredentials.new, **options)
        @access_token = AccessToken.new(client_id:, client_secret:, **options)
        @service = Cerbos::Service.new(stub:, credentials:, **options)
      end

      def call(rpc, request, metadata)
        access_token = @access_token.fetch
        Hub.with_circuit_breaker { @service.call(rpc, request, metadata.merge({"x-cerbos-auth": access_token})) }
      end
    end
  end
end
