# frozen_string_literal: true

module Cerbos
  module Input
    # A resource on which to check a principal's permissions.
    class Resource
      # The type of resource.
      #
      # @return [String]
      attr_reader :kind

      # A unique identifier for the resource.
      #
      # @return [String]
      attr_reader :id

      # Application-specific attributes describing the resource.
      #
      # @return [Attributes]
      attr_reader :attributes

      # The policy version to use when checking the principal's permissions on the resource.
      #
      # @return [String]
      # @return [nil] if not provided (in which case the Cerbos policy decision point server's configured default version will be used).
      attr_reader :policy_version

      # The policy scope to use when checking the principal's permissions on the resource.
      #
      # @return [String]
      # @return [nil] if not provided.
      #
      # @see https://docs.cerbos.dev/cerbos/latest/policies/scoped_policies.html Scoped policies
      attr_reader :scope

      # Specify a resource on which to check a principal's permissions.
      #
      # @param kind [String] the type of resource.
      # @param id [String] a unique identifier for the resource.
      # @param attributes [Attributes, Hash] application-specific attributes describing the resource.
      # @param policy_version [String, nil] the policy version to use when checking the principal's permissions on the resource (`nil` to use the Cerbos policy decision point server's configured default version).
      # @param scope [String, nil] the policy scope to use when checking the principal's permissions on the resource.
      def initialize(kind:, id:, attributes: {}, policy_version: nil, scope: nil)
        @kind = kind
        @id = id
        @attributes = Input.coerce_required(attributes, Attributes)
        @policy_version = policy_version
        @scope = scope
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Engine::V1::Resource.new(
          kind: kind,
          id: id,
          attr: attributes.to_protobuf,
          policy_version: policy_version,
          scope: scope
        )
      end
    end
  end
end
