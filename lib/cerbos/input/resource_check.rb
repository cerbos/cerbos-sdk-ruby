# frozen_string_literal: true

module Cerbos
  module Input
    # A resource and actions to check a principal's permissions.
    class ResourceCheck
      # The resource to check.
      #
      # @return [Resource]
      attr_reader :resource

      # The actions to check.
      #
      # @return [Array<String>]
      attr_reader :actions

      # Specify a resource and actions to check a principal's permissions.
      #
      # @param resource [Resource, Hash] the resource to check.
      # @param actions [Array<String>] the actions to check.
      def initialize(resource:, actions:)
        @resource = Input.coerce_required(resource, Resource)
        @actions = actions
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Request::V1::CheckResourcesRequest::ResourceEntry.new(
          resource: resource.to_protobuf,
          actions: actions
        )
      end
    end
  end
end
