# frozen_string_literal: true

module Cerbos
  module Output
    # The outcome of checking a principal's permissions on a set of resources.
    #
    # @see Client#check_resources
    CheckResources = Output.new_class(:request_id, :results) do
      # @!attribute [r] request_id
      #   @return [string] the identifier for tracing the request.

      # @!attribute [r] results
      #   @return [Array<Result>] the permissions checks for each resource.

      def self.from_protobuf(check_resources)
        new(
          request_id: check_resources.request_id,
          results: (check_resources.results || []).map { |entry| CheckResources::Result.from_protobuf(entry) }
        )
      end

      # Check the policy decision was that an action should be allowed for a resource.
      #
      # @param resource [Input::Resource, Hash] the resource search criteria (see {#find_result}).
      # @param action [String] the action to check.
      #
      # @return [Boolean] whether the action should be allowed.
      # @return [nil] if the resource or action is not present in the results.
      def allow?(resource:, action:)
        find_result(resource)&.allow?(action)
      end

      # Find an item from {#results} by resource.
      #
      # @param resource [Input::Resource, Hash] the resource search criteria. `kind` and `id` are required; `policy_version` and `scope` may also be provided if needed to distinguish between multiple results for the same `kind` and `id`.
      #
      # @return [Result] the first result with a matching resource.
      # @return [nil] if not found.
      def find_result(resource)
        search = Input.coerce_required(resource, Input::Resource)
        results.find { |result| matching_resource?(search, result.resource) }
      end

      private

      def matching_resource?(search, candidate)
        search.kind == candidate.kind &&
          search.id == candidate.id &&
          (search.policy_version.nil? || search.policy_version == candidate.policy_version) &&
          (search.scope.nil? || search.scope == candidate.scope)
      end
    end

    # The outcome of checking a principal's permissions on single resource.
    CheckResources::Result = Output.new_class(:resource, :actions, :validation_errors, :metadata) do
      # @!attribute [r] resource
      #   @return [Resource] the resource that was checked.

      # @!attribute [r] actions
      #   @return [Hash{String => :EFFECT_ALLOW, :EFFECT_DENY}] the policy decisions for each action.

      # @!attribute [r] validation_errors
      #   @return [Array<ValidationError>] any schema validation errors for the principal or resource attributes.

      # @!attribute [r] metadata
      #   Additional information about how the policy decisions were reached.
      #
      #   @return [Metadata] additional information about how the policy decisions were reached.
      #   @return [nil] if `include_metadata` was `false`.

      def self.from_protobuf(entry)
        new(
          resource: CheckResources::Result::Resource.from_protobuf(entry.resource),
          actions: entry.actions.to_h,
          validation_errors: (entry.validation_errors || []).map { |validation_error| CheckResources::Result::ValidationError.from_protobuf(validation_error) },
          metadata: CheckResources::Result::Metadata.from_protobuf(entry.meta)
        )
      end

      # Check if the policy decision was that a given action should be allowed for the resource.
      #
      # @return [Boolean] whether the action should be allowed.
      # @return [nil] if the action is not present in the results.
      def allow?(action)
        actions[action]&.eql?(:EFFECT_ALLOW)
      end

      # List the actions that should be allowed for the resource.
      #
      # @return [Array<String>] the actions that should be allowed for the resource.
      def allowed_actions
        actions.filter_map { |action, effect| action if effect == :EFFECT_ALLOW }
      end
    end

    # A resource that was checked.
    CheckResources::Result::Resource = Output.new_class(:kind, :id, :policy_version, :scope) do
      # @!attribute [r] kind
      #   @return [String] the kind of resource.

      # @!attribute [r] id
      #   @return [String] the id of the resource.

      # @!attribute [r] policy_version
      #   @return [String] the policy version against which the check was performed.

      # @!attribute [r] scope
      #   @return [String] the scope against which the check was performed.
      #
      #   @see https://docs.cerbos.dev/cerbos/latest/policies/scoped_policies.html Scoped policies

      def self.from_protobuf(resource)
        new(
          kind: resource.kind,
          id: resource.id,
          policy_version: resource.policy_version,
          scope: resource.scope
        )
      end
    end

    # An error that occurred while validating the principal or resource attributes against a schema.
    CheckResources::Result::ValidationError = Output.new_class(:path, :message, :source) do
      # @!attribute [r] path
      #   @return [String] the path to the attribute that failed validation.

      # @!attribute [r] message
      #   @return [String] the error message.

      # @!attribute [r] source
      #   @return [:SOURCE_PRINCIPAL, :SOURCE_RESOURCE] the source of the invalid attributes.

      def self.from_protobuf(validation_error)
        new(
          path: validation_error.path,
          message: validation_error.message,
          source: validation_error.source
        )
      end

      # Check if the principal failed schema validation.
      #
      # @return [Boolean] whether the source of the validation error was the principal attributes.
      def from_principal?
        source == :SOURCE_PRINCIPAL
      end

      # Check if the resource failed schema validation.
      #
      # @return [Boolean] whether the source of the validation error was the resource attributes.
      def from_resource?
        source == :SOURCE_RESOURCE
      end
    end

    # Additional information about how policy decisions were reached.
    CheckResources::Result::Metadata = Output.new_class(:actions, :effective_derived_roles) do
      # @!attribute [r] actions
      #   @return [Hash{String => Effect}] additional information about how the policy decision was reached for each action.

      # @!attribute [r] effective_derived_roles
      #   @return [Array<String>] the derived roles that were applied to the principal for the resource.
      #
      #   @see https://docs.cerbos.dev/cerbos/latest/policies/derived_roles.html Derived roles

      def self.from_protobuf(meta)
        return nil if meta.nil?

        new(
          actions: meta.actions.map { |action, effect| [action, CheckResources::Result::Metadata::Effect.from_protobuf(effect)] }.to_h,
          effective_derived_roles: meta.effective_derived_roles || []
        )
      end
    end

    # Additional information about how a policy decision was reached.
    CheckResources::Result::Metadata::Effect = Output.new_class(:matched_policy, :matched_scope) do
      # @!attribute [r] matched_policy
      #   @return [String] the policy that was used to make the decision.

      # @!attribute [r] matched_scope
      #   @return [String] the policy scope that was used to make the decision.
      #
      #   @see https://docs.cerbos.dev/cerbos/latest/policies/scoped_policies.html Scoped policies

      def self.from_protobuf(effect_meta)
        new(
          matched_policy: effect_meta.matched_policy,
          matched_scope: effect_meta.matched_scope
        )
      end
    end
  end
end
