# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: cerbos/audit/v1/audit.proto

require 'google/protobuf'

require 'cerbos/protobuf/cerbos/engine/v1/engine_pb'
require 'google/protobuf/timestamp_pb'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("cerbos/audit/v1/audit.proto", :syntax => :proto3) do
    add_message "cerbos.audit.v1.AccessLogEntry" do
      optional :call_id, :string, 1, json_name: "callId"
      optional :timestamp, :message, 2, "google.protobuf.Timestamp", json_name: "timestamp"
      optional :peer, :message, 3, "cerbos.audit.v1.Peer", json_name: "peer"
      map :metadata, :string, :message, 4, "cerbos.audit.v1.MetaValues"
      optional :method, :string, 5, json_name: "method"
      optional :status_code, :uint32, 6, json_name: "statusCode"
    end
    add_message "cerbos.audit.v1.DecisionLogEntry" do
      optional :call_id, :string, 1, json_name: "callId"
      optional :timestamp, :message, 2, "google.protobuf.Timestamp", json_name: "timestamp"
      optional :peer, :message, 3, "cerbos.audit.v1.Peer", json_name: "peer"
      repeated :inputs, :message, 4, "cerbos.engine.v1.CheckInput", json_name: "inputs"
      repeated :outputs, :message, 5, "cerbos.engine.v1.CheckOutput", json_name: "outputs"
      optional :error, :string, 6, json_name: "error"
      oneof :method do
        optional :check_resources, :message, 7, "cerbos.audit.v1.DecisionLogEntry.CheckResources", json_name: "checkResources"
        optional :plan_resources, :message, 8, "cerbos.audit.v1.DecisionLogEntry.PlanResources", json_name: "planResources"
      end
    end
    add_message "cerbos.audit.v1.DecisionLogEntry.CheckResources" do
      repeated :inputs, :message, 1, "cerbos.engine.v1.CheckInput", json_name: "inputs"
      repeated :outputs, :message, 2, "cerbos.engine.v1.CheckOutput", json_name: "outputs"
      optional :error, :string, 3, json_name: "error"
    end
    add_message "cerbos.audit.v1.DecisionLogEntry.PlanResources" do
      optional :input, :message, 1, "cerbos.engine.v1.PlanResourcesInput", json_name: "input"
      optional :output, :message, 2, "cerbos.engine.v1.PlanResourcesOutput", json_name: "output"
      optional :error, :string, 3, json_name: "error"
    end
    add_message "cerbos.audit.v1.MetaValues" do
      repeated :values, :string, 1, json_name: "values"
    end
    add_message "cerbos.audit.v1.Peer" do
      optional :address, :string, 1, json_name: "address"
      optional :auth_info, :string, 2, json_name: "authInfo"
      optional :user_agent, :string, 3, json_name: "userAgent"
      optional :forwarded_for, :string, 4, json_name: "forwardedFor"
    end
  end
end

module Cerbos::Protobuf::Cerbos
  module Audit
    module V1
      AccessLogEntry = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.audit.v1.AccessLogEntry").msgclass
      DecisionLogEntry = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.audit.v1.DecisionLogEntry").msgclass
      DecisionLogEntry::CheckResources = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.audit.v1.DecisionLogEntry.CheckResources").msgclass
      DecisionLogEntry::PlanResources = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.audit.v1.DecisionLogEntry.PlanResources").msgclass
      MetaValues = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.audit.v1.MetaValues").msgclass
      Peer = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.audit.v1.Peer").msgclass
    end
  end
end
