# frozen_string_literal: true

module Cerbos
  module Input
    # Partial details of resources to be queried.
    class ResourceQuery
      # @return [String] the type of resources to be queried.
      attr_reader :kind

      # @return [Attributes] any application-specific attributes describing the resources to be queried that are known in advance.
      attr_reader :attributes

      # The policy version to use when planning the query.
      #
      # @return [String] the policy version to use when planning the query.
      # @return [nil] if not provided (in which case the Cerbos policy decision point server's configured default version will be used).
      attr_reader :policy_version

      # The policy scope to use when planning the query.
      #
      # @return [String] the policy scope to use when planning the query.
      # @return [nil] if not provided.
      #
      # @see https://docs.cerbos.dev/cerbos/latest/policies/scoped_policies.html Scoped policies
      attr_reader :scope

      # Specify partial details of resources to be queried.
      #
      # @param kind [String] the type of resources to be queried.
      # @param attributes [Attributes, Hash] any application-specific attributes describing the resources to be queried that are known in advance.
      # @param policy_version [String, nil] the policy version to use when planning the query (`nil` to use the Cerbos policy decision point server's configured default version).
      # @param scope [String, nil] the policy scope to use when planning the query.
      def initialize(kind:, attributes: {}, policy_version: nil, scope: nil)
        @kind = kind
        @attributes = Input.coerce_required(attributes, Attributes)
        @policy_version = policy_version
        @scope = scope
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Engine::V1::PlanResourcesRequest::Resource.new(
          kind: kind,
          attr: attributes.to_protobuf,
          policy_version: policy_version,
          scope: scope
        )
      end
    end
  end
end
