# frozen_string_literal: true

module Cerbos
  module Hub
    # @private
    class Service
      def initialize(client_id:, client_secret:, stub:, **options)
        @access_token = AccessToken.new(client_id:, client_secret:, **options)
        @service = Cerbos::Service.new(stub:, credentials: GRPC::Core::ChannelCredentials.new, **options)
      end

      def call(rpc, request, metadata)
        @service.call(rpc, request, metadata.merge("x-cerbos-auth": @access_token.fetch))
      end
    end
  end
end
