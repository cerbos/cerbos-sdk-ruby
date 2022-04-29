# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: cerbos/engine/v1/engine.proto

require 'google/protobuf'

require 'cerbos/protobuf/cerbos/effect/v1/effect_pb'
require 'cerbos/protobuf/cerbos/schema/v1/schema_pb'
require 'cerbos/protobuf/google/api/expr/v1alpha1/checked_pb'
require 'cerbos/protobuf/google/api/field_behavior_pb'
require 'google/protobuf/struct_pb'
require 'cerbos/protobuf/protoc-gen-openapiv2/options/annotations_pb'
require 'cerbos/protobuf/validate/validate_pb'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("cerbos/engine/v1/engine.proto", :syntax => :proto3) do
    add_message "cerbos.engine.v1.PlanResourcesRequest" do
      optional :request_id, :string, 1, json_name: "requestId"
      optional :action, :string, 2, json_name: "action"
      optional :principal, :message, 3, "cerbos.engine.v1.Principal", json_name: "principal"
      optional :resource, :message, 4, "cerbos.engine.v1.PlanResourcesRequest.Resource", json_name: "resource"
      optional :aux_data, :message, 5, "cerbos.engine.v1.AuxData", json_name: "auxData"
      optional :include_meta, :bool, 6, json_name: "includeMeta"
    end
    add_message "cerbos.engine.v1.PlanResourcesRequest.Resource" do
      optional :kind, :string, 1, json_name: "kind"
      map :attr, :string, :message, 2, "google.protobuf.Value"
      optional :policy_version, :string, 3, json_name: "policyVersion"
      optional :scope, :string, 4, json_name: "scope"
    end
    add_message "cerbos.engine.v1.CheckInput" do
      optional :request_id, :string, 1, json_name: "requestId"
      optional :resource, :message, 2, "cerbos.engine.v1.Resource", json_name: "resource"
      optional :principal, :message, 3, "cerbos.engine.v1.Principal", json_name: "principal"
      repeated :actions, :string, 4, json_name: "actions"
      optional :aux_data, :message, 5, "cerbos.engine.v1.AuxData", json_name: "auxData"
    end
    add_message "cerbos.engine.v1.CheckOutput" do
      optional :request_id, :string, 1, json_name: "requestId"
      optional :resource_id, :string, 2, json_name: "resourceId"
      map :actions, :string, :message, 3, "cerbos.engine.v1.CheckOutput.ActionEffect"
      repeated :effective_derived_roles, :string, 4, json_name: "effectiveDerivedRoles"
      repeated :validation_errors, :message, 5, "cerbos.schema.v1.ValidationError", json_name: "validationErrors"
    end
    add_message "cerbos.engine.v1.CheckOutput.ActionEffect" do
      optional :effect, :enum, 1, "cerbos.effect.v1.Effect", json_name: "effect"
      optional :policy, :string, 2, json_name: "policy"
      optional :scope, :string, 3, json_name: "scope"
    end
    add_message "cerbos.engine.v1.PlanResourcesOutput" do
      optional :request_id, :string, 1, json_name: "requestId"
      optional :action, :string, 2, json_name: "action"
      optional :kind, :string, 3, json_name: "kind"
      optional :policy_version, :string, 4, json_name: "policyVersion"
      optional :scope, :string, 5, json_name: "scope"
      optional :filter, :message, 6, "cerbos.engine.v1.PlanResourcesOutput.Node", json_name: "filter"
    end
    add_message "cerbos.engine.v1.PlanResourcesOutput.Node" do
      oneof :node do
        optional :logical_operation, :message, 1, "cerbos.engine.v1.PlanResourcesOutput.LogicalOperation", json_name: "logicalOperation"
        optional :expression, :message, 2, "google.api.expr.v1alpha1.CheckedExpr", json_name: "expression"
      end
    end
    add_message "cerbos.engine.v1.PlanResourcesOutput.LogicalOperation" do
      optional :operator, :enum, 1, "cerbos.engine.v1.PlanResourcesOutput.LogicalOperation.Operator", json_name: "operator"
      repeated :nodes, :message, 2, "cerbos.engine.v1.PlanResourcesOutput.Node", json_name: "nodes"
    end
    add_enum "cerbos.engine.v1.PlanResourcesOutput.LogicalOperation.Operator" do
      value :OPERATOR_UNSPECIFIED, 0
      value :OPERATOR_AND, 1
      value :OPERATOR_OR, 2
      value :OPERATOR_NOT, 3
    end
    add_message "cerbos.engine.v1.Resource" do
      optional :kind, :string, 1, json_name: "kind"
      optional :policy_version, :string, 2, json_name: "policyVersion"
      optional :id, :string, 3, json_name: "id"
      map :attr, :string, :message, 4, "google.protobuf.Value"
      optional :scope, :string, 5, json_name: "scope"
    end
    add_message "cerbos.engine.v1.Principal" do
      optional :id, :string, 1, json_name: "id"
      optional :policy_version, :string, 2, json_name: "policyVersion"
      repeated :roles, :string, 3, json_name: "roles"
      map :attr, :string, :message, 4, "google.protobuf.Value"
      optional :scope, :string, 5, json_name: "scope"
    end
    add_message "cerbos.engine.v1.AuxData" do
      map :jwt, :string, :message, 1, "google.protobuf.Value"
    end
    add_message "cerbos.engine.v1.Trace" do
      repeated :components, :message, 1, "cerbos.engine.v1.Trace.Component", json_name: "components"
      optional :event, :message, 2, "cerbos.engine.v1.Trace.Event", json_name: "event"
    end
    add_message "cerbos.engine.v1.Trace.Component" do
      optional :kind, :enum, 1, "cerbos.engine.v1.Trace.Component.Kind", json_name: "kind"
      oneof :details do
        optional :action, :string, 2, json_name: "action"
        optional :derived_role, :string, 3, json_name: "derivedRole"
        optional :expr, :string, 4, json_name: "expr"
        optional :index, :uint32, 5, json_name: "index"
        optional :policy, :string, 6, json_name: "policy"
        optional :resource, :string, 7, json_name: "resource"
        optional :rule, :string, 8, json_name: "rule"
        optional :scope, :string, 9, json_name: "scope"
        optional :variable, :message, 10, "cerbos.engine.v1.Trace.Component.Variable", json_name: "variable"
      end
    end
    add_message "cerbos.engine.v1.Trace.Component.Variable" do
      optional :name, :string, 1, json_name: "name"
      optional :expr, :string, 2, json_name: "expr"
    end
    add_enum "cerbos.engine.v1.Trace.Component.Kind" do
      value :KIND_UNSPECIFIED, 0
      value :KIND_ACTION, 1
      value :KIND_CONDITION_ALL, 2
      value :KIND_CONDITION_ANY, 3
      value :KIND_CONDITION_NONE, 4
      value :KIND_CONDITION, 5
      value :KIND_DERIVED_ROLE, 6
      value :KIND_EXPR, 7
      value :KIND_POLICY, 8
      value :KIND_RESOURCE, 9
      value :KIND_RULE, 10
      value :KIND_SCOPE, 11
      value :KIND_VARIABLE, 12
      value :KIND_VARIABLES, 13
    end
    add_message "cerbos.engine.v1.Trace.Event" do
      optional :status, :enum, 1, "cerbos.engine.v1.Trace.Event.Status", json_name: "status"
      optional :effect, :enum, 2, "cerbos.effect.v1.Effect", json_name: "effect"
      optional :error, :string, 3, json_name: "error"
      optional :message, :string, 4, json_name: "message"
      optional :result, :message, 5, "google.protobuf.Value", json_name: "result"
    end
    add_enum "cerbos.engine.v1.Trace.Event.Status" do
      value :STATUS_UNSPECIFIED, 0
      value :STATUS_ACTIVATED, 1
      value :STATUS_SKIPPED, 2
    end
  end
end

module Cerbos::Protobuf::Cerbos
  module Engine
    module V1
      PlanResourcesRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.PlanResourcesRequest").msgclass
      PlanResourcesRequest::Resource = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.PlanResourcesRequest.Resource").msgclass
      CheckInput = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.CheckInput").msgclass
      CheckOutput = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.CheckOutput").msgclass
      CheckOutput::ActionEffect = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.CheckOutput.ActionEffect").msgclass
      PlanResourcesOutput = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.PlanResourcesOutput").msgclass
      PlanResourcesOutput::Node = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.PlanResourcesOutput.Node").msgclass
      PlanResourcesOutput::LogicalOperation = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.PlanResourcesOutput.LogicalOperation").msgclass
      PlanResourcesOutput::LogicalOperation::Operator = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.PlanResourcesOutput.LogicalOperation.Operator").enummodule
      Resource = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.Resource").msgclass
      Principal = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.Principal").msgclass
      AuxData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.AuxData").msgclass
      Trace = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.Trace").msgclass
      Trace::Component = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.Trace.Component").msgclass
      Trace::Component::Variable = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.Trace.Component.Variable").msgclass
      Trace::Component::Kind = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.Trace.Component.Kind").enummodule
      Trace::Event = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.Trace.Event").msgclass
      Trace::Event::Status = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.engine.v1.Trace.Event.Status").enummodule
    end
  end
end
