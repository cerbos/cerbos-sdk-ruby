# frozen_string_literal: true

module Cerbos
  module Output
    # A query plan that can be used to obtain a list of resources on which a principal is allowed to perform a particular action.
    #
    # @see Client#plan_resources
    PlanResources = Output.new_class(:request_id, :kind, :condition, :metadata) do
      # @!attribute [r] request_id
      #   The identifier for tracing the request.
      #
      #   @return [String]

      # @!attribute [r] kind
      #   The type of plan.
      #
      #   @return [:KIND_ALWAYS_ALLOWED, :KIND_ALWAYS_DENIED, :KIND_CONDITIONAL]

      # @!attribute [r] condition
      #   The root node of the query condition abstract syntax tree.
      #
      #   @return [Expression, Expression::Variable]
      #   @return [nil] if the specified action is not conditional (is always allowed or denied) for the principal on resources matching the input.
      #
      #   @see #always_allowed?
      #   @see #always_denied?
      #   @see #conditional?

      # @!attribute [r] metadata
      #   Additional information about the query plan.
      #
      #   @return [Metadata]
      #   @return [nil] if `include_metadata` was `false`.

      def self.from_protobuf(plan_resources)
        new(
          request_id: plan_resources.request_id,
          kind: plan_resources.filter.kind,
          condition: PlanResources::Expression::Operand.from_protobuf(plan_resources.filter.condition),
          metadata: PlanResources::Metadata.from_protobuf(plan_resources.meta)
        )
      end

      # Check if the specified action is always allowed for the principal on resources matching the input.
      #
      # @return [Boolean]
      def always_allowed?
        kind == :KIND_ALWAYS_ALLOWED
      end

      # Check if the specified action is always denied for the principal on resources matching the input.
      #
      # @return [Boolean]
      def always_denied?
        kind == :KIND_ALWAYS_DENIED
      end

      # Check if the specified action is conditionally allowed for the principal on resources matching the input.
      #
      # @return [Boolean]
      def conditional?
        kind == :KIND_CONDITIONAL
      end
    end

    # An abstract syntax tree node representing an expression to evaluate.
    PlanResources::Expression = Output.new_class(:operator, :operands) do
      # @!attribute [r] operator
      #   The operator to invoke.
      #
      #   @return [String]

      # @!attribute [r] operands
      #   The operands on which to invoke the operator.
      #
      #   @return [Array<Expression, Value, Variable>]

      def self.from_protobuf(expression)
        new(
          operator: expression.operator,
          operands: (expression.operands || []).map { |operand| PlanResources::Expression::Operand.from_protobuf(operand) }
        )
      end
    end

    # @private
    module PlanResources::Expression::Operand
      def self.from_protobuf(operand)
        if operand.nil?
          nil
        elsif operand.has_expression?
          PlanResources::Expression.from_protobuf(operand.expression)
        elsif operand.has_value?
          PlanResources::Expression::Value.from_protobuf(operand.value)
        else
          PlanResources::Expression::Variable.from_protobuf(operand.variable)
        end
      end
    end

    # An abstract syntax tree node representing a constant value.
    PlanResources::Expression::Value = Output.new_class(:value) do
      # @!attribute [r] value
      #   The constant value.
      #
      #   @return [String, Numeric, Boolean, Array, Hash, nil]

      def self.from_protobuf(value)
        new(value: value.to_ruby(true))
      end
    end

    # An abstract syntax tree node representing a variable whose value was unknown when producing the query plan.
    PlanResources::Expression::Variable = Output.new_class(:name) do
      # @!attribute [r] name
      #   The name of the variable.
      #
      #   @return [String]

      def self.from_protobuf(variable)
        new(name: variable)
      end
    end

    # Additional information about the query plan.
    PlanResources::Metadata = Output.new_class(:condition_string, :matched_scope) do
      # @!attribute [r] condition_string
      #   The query condition abstract syntax tree rendered as a human-readable string, to help with debugging.
      #
      #   @return [String]

      # @!attribute [r] matched_scope
      #   The policy scope that was used to plan the query.
      #
      #   @return [String]
      #
      #   @see https://docs.cerbos.dev/cerbos/latest/policies/scoped_policies.html Scoped policies

      def self.from_protobuf(meta)
        return nil if meta.nil?

        new(
          condition_string: meta.filter_debug,
          matched_scope: meta.matched_scope
        )
      end
    end
  end
end
