# frozen_string_literal: true

module Cerbos
  module Input
    # Partial details of resources to be queried.
    class ResourceQuery
      # The type of resources to be queried.
      #
      # @return [String]
      attr_reader :kind

      # Any application-specific attributes describing the resources to be queried that are known in advance.
      #
      # @return [Attributes]
      attr_reader :attr

      # The policy version to use when planning the query.
      #
      # @return [String]
      # @return [nil] if not provided (in which case the Cerbos policy decision point server's configured default version will be used).
      attr_reader :policy_version

      # The policy scope to use when planning the query.
      #
      # @return [String]
      # @return [nil] if not provided.
      #
      # @see https://docs.cerbos.dev/cerbos/latest/policies/scoped_policies.html Scoped policies
      attr_reader :scope

      # Specify partial details of resources to be queried.
      #
      # @param kind [String] the type of resources to be queried.
      # @param attr [Attributes, Hash] any application-specific attributes describing the resources to be queried that are known in advance.
      # @param attributes [Attributes, Hash] deprecated (use `attr` instead).
      # @param policy_version [String, nil] the policy version to use when planning the query (`nil` to use the Cerbos policy decision point server's configured default version).
      # @param scope [String, nil] the policy scope to use when planning the query.
      def initialize(kind:, attr: {}, attributes: nil, policy_version: nil, scope: nil)
        unless attributes.nil?
          Cerbos.deprecation_warning "The `attributes` keyword argument is deprecated. Use `attr` instead."
          attr = attributes
        end

        @kind = kind
        @attr = Input.coerce_required(attr, Attributes)
        @policy_version = policy_version
        @scope = scope
      end

      # Any application-specific attributes describing the resources to be queried that are known in advance.
      #
      # @deprecated Use {#attr} instead.
      # @return [Attributes]
      def attributes
        Cerbos.deprecation_warning "The `attributes` method is deprecated. Use `attr` instead."
        attr
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Engine::V1::PlanResourcesInput::Resource.new(
          kind: kind,
          attr: attr.to_protobuf,
          policy_version: policy_version,
          scope: scope
        )
      end
    end
  end
end
