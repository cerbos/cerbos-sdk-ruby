# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: cerbos/svc/v1/svc.proto

require 'google/protobuf'

require 'cerbos/protobuf/cerbos/request/v1/request_pb'
require 'cerbos/protobuf/cerbos/response/v1/response_pb'
require 'cerbos/protobuf/google/api/annotations_pb'
require 'cerbos/protobuf/protoc-gen-openapiv2/options/annotations_pb'


descriptor_data = "\n\x17\x63\x65rbos/svc/v1/svc.proto\x12\rcerbos.svc.v1\x1a\x1f\x63\x65rbos/request/v1/request.proto\x1a!cerbos/response/v1/response.proto\x1a\x1cgoogle/api/annotations.proto\x1a.protoc-gen-openapiv2/options/annotations.proto2\xd6\n\n\rCerbosService\x12\xa7\x02\n\x10\x43heckResourceSet\x12*.cerbos.request.v1.CheckResourceSetRequest\x1a,.cerbos.response.v1.CheckResourceSetResponse\"\xb8\x01\x92\x41\x9f\x01\x12\x05\x43heck\x1a\x93\x01[Deprecated: Use CheckResources API instead] Check whether a principal has permissions to perform the given actions on a set of resource instances.X\x01\x82\xd3\xe4\x93\x02\x0f:\x01*\"\n/api/check\x12\xb6\x02\n\x12\x43heckResourceBatch\x12,.cerbos.request.v1.CheckResourceBatchRequest\x1a..cerbos.response.v1.CheckResourceBatchResponse\"\xc1\x01\x92\x41\x99\x01\x12\x14\x43heck resource batch\x1a\x7f[Deprecated: Use CheckResources API instead] Check a principal\'s permissions to a batch of heterogeneous resources and actions.X\x01\x82\xd3\xe4\x93\x02\x1e:\x01*\"\x19/api/check_resource_batch\x12\xf0\x01\n\x0e\x43heckResources\x12(.cerbos.request.v1.CheckResourcesRequest\x1a*.cerbos.response.v1.CheckResourcesResponse\"\x87\x01\x92\x41\x65\x12\x0f\x43heck resources\x1aRCheck a principal\'s permissions to a batch of heterogeneous resources and actions.\x82\xd3\xe4\x93\x02\x19:\x01*\"\x14/api/check/resources\x12\xc5\x01\n\nServerInfo\x12$.cerbos.request.v1.ServerInfoRequest\x1a&.cerbos.response.v1.ServerInfoResponse\"i\x92\x41N\x12\x16Get server information\x1a\x34Get information about the server e.g. server version\x82\xd3\xe4\x93\x02\x12\x12\x10/api/server_info\x12\x83\x02\n\rPlanResources\x12\'.cerbos.request.v1.PlanResourcesRequest\x1a).cerbos.response.v1.PlanResourcesResponse\"\x9d\x01\x92\x41|\x12\x0ePlan resources\x1ajProduce a query plan with conditions that must be satisfied for accessing a set of instances of a resource\x82\xd3\xe4\x93\x02\x18:\x01*\"\x13/api/plan/resources\x1a!\x92\x41\x1e\x12\x1c\x43\x65rbos Policy Decision PointB\xe1\x01\n\x15\x64\x65v.cerbos.api.v1.svcZ6github.com/cerbos/cerbos/api/genpb/cerbos/svc/v1;svcv1\xaa\x02\x11\x43\x65rbos.Api.V1.Svc\x92\x41{\x12?\n\x06\x43\x65rbos\"-\n\x06\x43\x65rbos\x12\x12https://cerbos.dev\x1a\x0finfo@cerbos.dev2\x06latest*\x01\x02\x32\x10\x61pplication/json:\x10\x61pplication/jsonZ\x11\n\x0f\n\tBasicAuth\x12\x02\x08\x01\x62\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool
pool.add_serialized_file(descriptor_data)

module Cerbos::Protobuf::Cerbos
  module Svc
    module V1
    end
  end
end
