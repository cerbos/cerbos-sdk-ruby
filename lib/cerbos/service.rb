# frozen_string_literal: true

module Cerbos
  # @private
  class Service
    def initialize(stub:, target:, credentials:, grpc_channel_args:, grpc_metadata:, timeout:)
      @metadata = grpc_metadata.transform_keys(&:to_sym)

      Error.handle do
        @service = stub.new(
          target,
          credentials,
          channel_args: grpc_channel_args.merge({
            "grpc.primary_user_agent" => [grpc_channel_args["grpc.primary_user_agent"], "cerbos-sdk-ruby/#{VERSION}"].compact.join(" ")
          }),
          timeout:
        )
      end
    end

    def call(rpc, request, metadata)
      @service.public_send(rpc, request, metadata: merge_metadata(metadata))
    end

    private

    def merge_metadata(metadata)
      return @metadata if metadata.empty?

      @metadata.merge(metadata).transform_keys!(&:to_sym)
    end
  end
end
