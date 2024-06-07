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
      attr_reader :attr

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
      # @param attr [Attributes, Hash] application-specific attributes describing the resource.
      # @param attributes [Attributes, Hash] deprecated (use `attr` instead).
      # @param policy_version [String, nil] the policy version to use when checking the principal's permissions on the resource (`nil` to use the Cerbos policy decision point server's configured default version).
      # @param scope [String, nil] the policy scope to use when checking the principal's permissions on the resource.
      def initialize(kind:, id:, attr: {}, attributes: nil, policy_version: nil, scope: nil)
        unless attributes.nil?
          Cerbos.deprecation_warning "The `attributes` keyword argument is deprecated. Use `attr` instead."
          attr = attributes
        end

        @kind = kind
        @id = id
        @attr = Input.coerce_required(attr, Attributes)
        @policy_version = policy_version
        @scope = scope
      end

      # Application-specific attributes describing the resource.
      #
      # @deprecated Use {#attr} instead.
      # @return [Attributes]
      def attributes
        Cerbos.deprecation_warning "The `attributes` method is deprecated. Use `attr` instead."
        attr
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Engine::V1::Resource.new(
          kind: kind,
          id: id,
          attr: attr.to_protobuf,
          policy_version: policy_version,
          scope: scope
        )
      end
    end
  end
end
