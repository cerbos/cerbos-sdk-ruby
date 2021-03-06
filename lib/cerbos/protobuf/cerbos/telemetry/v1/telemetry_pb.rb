# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: cerbos/telemetry/v1/telemetry.proto

require 'google/protobuf'

require 'google/protobuf/duration_pb'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("cerbos/telemetry/v1/telemetry.proto", :syntax => :proto3) do
    add_message "cerbos.telemetry.v1.ServerLaunch" do
      optional :version, :string, 1, json_name: "version"
      optional :source, :message, 2, "cerbos.telemetry.v1.ServerLaunch.Source", json_name: "source"
      optional :features, :message, 3, "cerbos.telemetry.v1.ServerLaunch.Features", json_name: "features"
      optional :stats, :message, 4, "cerbos.telemetry.v1.ServerLaunch.Stats", json_name: "stats"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Cerbos" do
      optional :version, :string, 1, json_name: "version"
      optional :commit, :string, 2, json_name: "commit"
      optional :build_date, :string, 3, json_name: "buildDate"
      optional :module_version, :string, 4, json_name: "moduleVersion"
      optional :module_checksum, :string, 5, json_name: "moduleChecksum"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Source" do
      optional :cerbos, :message, 1, "cerbos.telemetry.v1.ServerLaunch.Cerbos", json_name: "cerbos"
      optional :os, :string, 2, json_name: "os"
      optional :arch, :string, 3, json_name: "arch"
      optional :num_cpus, :uint32, 4, json_name: "numCpus"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Features" do
      optional :audit, :message, 1, "cerbos.telemetry.v1.ServerLaunch.Features.Audit", json_name: "audit"
      optional :schema, :message, 2, "cerbos.telemetry.v1.ServerLaunch.Features.Schema", json_name: "schema"
      optional :admin_api, :message, 3, "cerbos.telemetry.v1.ServerLaunch.Features.AdminApi", json_name: "adminApi"
      optional :storage, :message, 4, "cerbos.telemetry.v1.ServerLaunch.Features.Storage", json_name: "storage"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Features.Audit" do
      optional :enabled, :bool, 1, json_name: "enabled"
      optional :backend, :string, 2, json_name: "backend"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Features.Schema" do
      optional :enforcement, :string, 1, json_name: "enforcement"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Features.AdminApi" do
      optional :enabled, :bool, 1, json_name: "enabled"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Features.Storage" do
      optional :driver, :string, 1, json_name: "driver"
      oneof :store do
        optional :disk, :message, 2, "cerbos.telemetry.v1.ServerLaunch.Features.Storage.Disk", json_name: "disk"
        optional :git, :message, 3, "cerbos.telemetry.v1.ServerLaunch.Features.Storage.Git", json_name: "git"
        optional :blob, :message, 4, "cerbos.telemetry.v1.ServerLaunch.Features.Storage.Blob", json_name: "blob"
      end
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Features.Storage.Disk" do
      optional :watch, :bool, 1, json_name: "watch"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Features.Storage.Git" do
      optional :protocol, :string, 1, json_name: "protocol"
      optional :auth, :bool, 2, json_name: "auth"
      optional :poll_interval, :message, 3, "google.protobuf.Duration", json_name: "pollInterval"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Features.Storage.Blob" do
      optional :provider, :string, 1, json_name: "provider"
      optional :poll_interval, :message, 2, "google.protobuf.Duration", json_name: "pollInterval"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Stats" do
      optional :policy, :message, 1, "cerbos.telemetry.v1.ServerLaunch.Stats.Policy", json_name: "policy"
      optional :schema, :message, 2, "cerbos.telemetry.v1.ServerLaunch.Stats.Schema", json_name: "schema"
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Stats.Policy" do
      map :count, :string, :uint32, 1
      map :avg_rule_count, :string, :double, 2
      map :avg_condition_count, :string, :double, 3
    end
    add_message "cerbos.telemetry.v1.ServerLaunch.Stats.Schema" do
      optional :count, :uint32, 1, json_name: "count"
    end
    add_message "cerbos.telemetry.v1.ServerStop" do
      optional :version, :string, 1, json_name: "version"
      optional :uptime, :message, 2, "google.protobuf.Duration", json_name: "uptime"
      optional :requests_total, :uint64, 3, json_name: "requestsTotal"
    end
    add_message "cerbos.telemetry.v1.Event" do
      oneof :data do
        optional :api_activity, :message, 1, "cerbos.telemetry.v1.Event.ApiActivity", json_name: "apiActivity"
      end
    end
    add_message "cerbos.telemetry.v1.Event.CountStat" do
      optional :key, :string, 1, json_name: "key"
      optional :count, :uint64, 2, json_name: "count"
    end
    add_message "cerbos.telemetry.v1.Event.ApiActivity" do
      optional :version, :string, 1, json_name: "version"
      optional :uptime, :message, 2, "google.protobuf.Duration", json_name: "uptime"
      repeated :method_calls, :message, 3, "cerbos.telemetry.v1.Event.CountStat", json_name: "methodCalls"
      repeated :user_agents, :message, 4, "cerbos.telemetry.v1.Event.CountStat", json_name: "userAgents"
    end
  end
end

module Cerbos::Protobuf::Cerbos
  module Telemetry
    module V1
      ServerLaunch = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch").msgclass
      ServerLaunch::Cerbos = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Cerbos").msgclass
      ServerLaunch::Source = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Source").msgclass
      ServerLaunch::Features = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Features").msgclass
      ServerLaunch::Features::Audit = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Features.Audit").msgclass
      ServerLaunch::Features::Schema = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Features.Schema").msgclass
      ServerLaunch::Features::AdminApi = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Features.AdminApi").msgclass
      ServerLaunch::Features::Storage = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Features.Storage").msgclass
      ServerLaunch::Features::Storage::Disk = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Features.Storage.Disk").msgclass
      ServerLaunch::Features::Storage::Git = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Features.Storage.Git").msgclass
      ServerLaunch::Features::Storage::Blob = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Features.Storage.Blob").msgclass
      ServerLaunch::Stats = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Stats").msgclass
      ServerLaunch::Stats::Policy = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Stats.Policy").msgclass
      ServerLaunch::Stats::Schema = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerLaunch.Stats.Schema").msgclass
      ServerStop = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.ServerStop").msgclass
      Event = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.Event").msgclass
      Event::CountStat = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.Event.CountStat").msgclass
      Event::ApiActivity = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.telemetry.v1.Event.ApiActivity").msgclass
    end
  end
end
