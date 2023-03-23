# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: cerbos/schema/v1/schema.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("cerbos/schema/v1/schema.proto", :syntax => :proto3) do
    add_message "cerbos.schema.v1.ValidationError" do
      optional :path, :string, 1, json_name: "path"
      optional :message, :string, 2, json_name: "message"
      optional :source, :enum, 3, "cerbos.schema.v1.ValidationError.Source", json_name: "source"
    end
    add_enum "cerbos.schema.v1.ValidationError.Source" do
      value :SOURCE_UNSPECIFIED, 0
      value :SOURCE_PRINCIPAL, 1
      value :SOURCE_RESOURCE, 2
    end
  end
end

module Cerbos::Protobuf::Cerbos
  module Schema
    module V1
      ValidationError = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.schema.v1.ValidationError").msgclass
      ValidationError::Source = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.schema.v1.ValidationError.Source").enummodule
    end
  end
end
