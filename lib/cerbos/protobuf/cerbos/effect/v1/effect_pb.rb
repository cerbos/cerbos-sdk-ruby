# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: cerbos/effect/v1/effect.proto

require 'google/protobuf'


descriptor_data = "\n\x1d\x63\x65rbos/effect/v1/effect.proto\x12\x10\x63\x65rbos.effect.v1*X\n\x06\x45\x66\x66\x65\x63t\x12\x16\n\x12\x45\x46\x46\x45\x43T_UNSPECIFIED\x10\x00\x12\x10\n\x0c\x45\x46\x46\x45\x43T_ALLOW\x10\x01\x12\x0f\n\x0b\x45\x46\x46\x45\x43T_DENY\x10\x02\x12\x13\n\x0f\x45\x46\x46\x45\x43T_NO_MATCH\x10\x03\x42o\n\x18\x64\x65v.cerbos.api.v1.effectZ<github.com/cerbos/cerbos/api/genpb/cerbos/effect/v1;effectv1\xaa\x02\x14\x43\x65rbos.Api.V1.Effectb\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool
pool.add_serialized_file(descriptor_data)

module Cerbos::Protobuf::Cerbos
  module Effect
    module V1
      Effect = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.effect.v1.Effect").enummodule
    end
  end
end
