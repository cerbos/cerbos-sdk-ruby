# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: cerbos/effect/v1/effect.proto

require 'google/protobuf'


descriptor_data = "\n\x1d\x63\x65rbos/effect/v1/effect.proto\x12\x10\x63\x65rbos.effect.v1*X\n\x06\x45\x66\x66\x65\x63t\x12\x16\n\x12\x45\x46\x46\x45\x43T_UNSPECIFIED\x10\x00\x12\x10\n\x0c\x45\x46\x46\x45\x43T_ALLOW\x10\x01\x12\x0f\n\x0b\x45\x46\x46\x45\x43T_DENY\x10\x02\x12\x13\n\x0f\x45\x46\x46\x45\x43T_NO_MATCH\x10\x03\x42o\n\x18\x64\x65v.cerbos.api.v1.effectZ<github.com/cerbos/cerbos/api/genpb/cerbos/effect/v1;effectv1\xaa\x02\x14\x43\x65rbos.Api.V1.Effectb\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool

begin
  pool.add_serialized_file(descriptor_data)
rescue TypeError => e
  # Compatibility code: will be removed in the next major version.
  require 'google/protobuf/descriptor_pb'
  parsed = Google::Protobuf::FileDescriptorProto.decode(descriptor_data)
  parsed.clear_dependency
  serialized = parsed.class.encode(parsed)
  file = pool.add_serialized_file(serialized)
  warn "Warning: Protobuf detected an import path issue while loading generated file #{__FILE__}"
  imports = [
  ]
  imports.each do |type_name, expected_filename|
    import_file = pool.lookup(type_name).file_descriptor
    if import_file.name != expected_filename
      warn "- #{file.name} imports #{expected_filename}, but that import was loaded as #{import_file.name}"
    end
  end
  warn "Each proto file must use a consistent fully-qualified name."
  warn "This will become an error in the next major version."
end

module Cerbos::Protobuf::Cerbos
  module Effect
    module V1
      Effect = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.effect.v1.Effect").enummodule
    end
  end
end
