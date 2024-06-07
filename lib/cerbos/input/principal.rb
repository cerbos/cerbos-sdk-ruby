# frozen_string_literal: true

module Cerbos
  module Input
    # A principal (often a user, but potentially another actor like a service account) to authorize.
    class Principal
      # A unique identifier for the principal.
      #
      # @return [String]
      attr_reader :id

      # The roles held by the principal.
      #
      # @return [Array<String>]
      attr_reader :roles

      # Application-specific attributes describing the principal.
      #
      # @return [Attributes]
      attr_reader :attr

      # The policy version to use when authorizing the principal.
      #
      # @return [String]
      # @return [nil] if not provided (in which case the Cerbos policy decision point server's configured default version will be used).
      attr_reader :policy_version

      # The policy scope to use when authorizing the principal.
      #
      # @return [String]
      # @return [nil] if not provided.
      #
      # @see https://docs.cerbos.dev/cerbos/latest/policies/scoped_policies.html Scoped policies
      attr_reader :scope

      # Specify a principal to authorize.
      #
      # @param id [String] a unique identifier for the principal.
      # @param roles [Array<String>] the roles held by the principal.
      # @param attr [Attributes, Hash] application-specific attributes describing the principal.
      # @param attributes [Attributes, Hash] deprecated (use `attr` instead).
      # @param policy_version [String, nil] the policy version to use when authorizing the principal (`nil` to use the Cerbos policy decision point server's configured default version).
      # @param scope [String, nil] the policy scope to use when authorizing the principal.
      def initialize(id:, roles:, attr: {}, attributes: nil, policy_version: nil, scope: nil)
        unless attributes.nil?
          Cerbos.deprecation_warning "The `attributes` keyword argument is deprecated. Use `attr` instead."
          attr = attributes
        end

        @id = id
        @roles = roles
        @attr = Input.coerce_required(attr, Attributes)
        @policy_version = policy_version
        @scope = scope
      end

      # Application-specific attributes describing the principal.
      #
      # @deprecated Use {#attr} instead.
      # @return [Attributes]
      def attributes
        Cerbos.deprecation_warning "The `attributes` method is deprecated. Use `attr` instead."
        attr
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Engine::V1::Principal.new(
          id: id,
          roles: roles,
          attr: attr.to_protobuf,
          policy_version: policy_version,
          scope: scope
        )
      end
    end
  end
end
