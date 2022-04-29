# frozen_string_literal: true

module Cerbos
  module Input
    # A principal (often a user, but potentially another actor like a service account) to authorize.
    class Principal
      # @return [String] a unique identifier for the principal.
      attr_reader :id

      # @return [Array<String>] the list of roles held by the principal.
      attr_reader :roles

      # @return [Attributes] application-specific attributes describing the principal.
      attr_reader :attributes

      # The policy version to use when authorizing the principal.
      #
      # @return [String] the policy version to use when authorizing the principal.
      # @return [nil] if not provided (in which case the Cerbos policy decision point server's configured default version will be used).
      attr_reader :policy_version

      # The policy scope to use when authorizing the principal.
      #
      # @return [String] the policy scope to use when authorizing the principal.
      # @return [nil] if not provided.
      #
      # @see https://docs.cerbos.dev/cerbos/latest/policies/scoped_policies.html Scoped policies
      attr_reader :scope

      # Specify a principal to authorize.
      #
      # @param id [String] a unique identifier for the principal.
      # @param roles [Array<String>] the list of roles held by the principal.
      # @param attributes [Attributes, Hash] application-specific attributes describing the principal.
      # @param policy_version [String, nil] the policy version to use when authorizing the principal (`nil` to use the Cerbos policy decision point server's configured default version).
      # @param scope [String, nil] the policy scope to use when authorizing the principal.
      def initialize(id:, roles:, attributes: {}, policy_version: nil, scope: nil)
        @id = id
        @roles = roles
        @attributes = Input.coerce_required(attributes, Attributes)
        @policy_version = policy_version
        @scope = scope
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Engine::V1::Principal.new(
          id: id,
          roles: roles,
          attr: attributes.to_protobuf,
          policy_version: policy_version,
          scope: scope
        )
      end
    end
  end
end
