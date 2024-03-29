# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: google/api/http.proto

require 'google/protobuf'


descriptor_data = "\n\x15google/api/http.proto\x12\ngoogle.api\"\xda\x02\n\x08HttpRule\x12\x1a\n\x08selector\x18\x01 \x01(\tR\x08selector\x12\x12\n\x03get\x18\x02 \x01(\tH\x00R\x03get\x12\x12\n\x03put\x18\x03 \x01(\tH\x00R\x03put\x12\x14\n\x04post\x18\x04 \x01(\tH\x00R\x04post\x12\x18\n\x06\x64\x65lete\x18\x05 \x01(\tH\x00R\x06\x64\x65lete\x12\x16\n\x05patch\x18\x06 \x01(\tH\x00R\x05patch\x12\x37\n\x06\x63ustom\x18\x08 \x01(\x0b\x32\x1d.google.api.CustomHttpPatternH\x00R\x06\x63ustom\x12\x12\n\x04\x62ody\x18\x07 \x01(\tR\x04\x62ody\x12#\n\rresponse_body\x18\x0c \x01(\tR\x0cresponseBody\x12\x45\n\x13\x61\x64\x64itional_bindings\x18\x0b \x03(\x0b\x32\x14.google.api.HttpRuleR\x12\x61\x64\x64itionalBindingsB\t\n\x07pattern\";\n\x11\x43ustomHttpPattern\x12\x12\n\x04kind\x18\x01 \x01(\tR\x04kind\x12\x12\n\x04path\x18\x02 \x01(\tR\x04pathBj\n\x0e\x63om.google.apiB\tHttpProtoP\x01ZAgoogle.golang.org/genproto/googleapis/api/annotations;annotations\xf8\x01\x01\xa2\x02\x04GAPIb\x06proto3"

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

module Cerbos::Protobuf::Google
  module Api
    HttpRule = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.HttpRule").msgclass
    CustomHttpPattern = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.CustomHttpPattern").msgclass
  end
end
