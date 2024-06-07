# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: cerbos/request/v1/request.proto

require 'google/protobuf'

require 'cerbos/protobuf/buf/validate/validate_pb'
require 'cerbos/protobuf/cerbos/engine/v1/engine_pb'
require 'cerbos/protobuf/google/api/field_behavior_pb'
require 'google/protobuf/struct_pb'
require 'cerbos/protobuf/protoc-gen-openapiv2/options/annotations_pb'


descriptor_data = "\n\x1f\x63\x65rbos/request/v1/request.proto\x12\x11\x63\x65rbos.request.v1\x1a\x1b\x62uf/validate/validate.proto\x1a\x1d\x63\x65rbos/engine/v1/engine.proto\x1a\x1fgoogle/api/field_behavior.proto\x1a\x1cgoogle/protobuf/struct.proto\x1a.protoc-gen-openapiv2/options/annotations.proto\"\x86\x05\n\x14PlanResourcesRequest\x12\x96\x01\n\nrequest_id\x18\x01 \x01(\tBw\x92\x41t2JOptional application-specific ID useful for correlating logs for analysis.J&\"c2db17b8-4f9f-4fb1-acfd-9162a02be42b\"R\trequestId\x12l\n\x06\x61\x63tion\x18\x02 \x01(\tBT\x92\x41\x43\x32\x32\x41\x63tion to be applied to each resource in the list.J\r\"view:public\"\xe2\x41\x01\x02\xbaH\x07\xc8\x01\x01r\x02\x10\x01R\x06\x61\x63tion\x12\x45\n\tprincipal\x18\x03 \x01(\x0b\x32\x1b.cerbos.engine.v1.PrincipalB\n\xe2\x41\x01\x02\xbaH\x03\xc8\x01\x01R\tprincipal\x12U\n\x08resource\x18\x04 \x01(\x0b\x32-.cerbos.engine.v1.PlanResourcesInput.ResourceB\n\xe2\x41\x01\x02\xbaH\x03\xc8\x01\x01R\x08resource\x12;\n\x08\x61ux_data\x18\x05 \x01(\x0b\x32\x1a.cerbos.request.v1.AuxDataB\x04\xe2\x41\x01\x01R\x07\x61uxData\x12\x63\n\x0cinclude_meta\x18\x06 \x01(\x08\x42@\x92\x41=2;Opt to receive request processing metadata in the response.R\x0bincludeMeta:\'\x92\x41$\n\"2 PDP Resources Query Plan Request\"\x8a\x05\n\x17\x43heckResourceSetRequest\x12\x96\x01\n\nrequest_id\x18\x01 \x01(\tBw\x92\x41t2JOptional application-specific ID useful for correlating logs for analysis.J&\"c2db17b8-4f9f-4fb1-acfd-9162a02be42b\"R\trequestId\x12\x90\x01\n\x07\x61\x63tions\x18\x02 \x03(\tBv\x92\x41\\28List of actions being performed on the set of resources.J\x1a[\"view:public\", \"comment\"]\xa8\x01\x01\xb0\x01\x01\xe2\x41\x01\x02\xbaH\x10\xc8\x01\x01\x92\x01\n\x08\x01\x18\x01\"\x04r\x02\x10\x01R\x07\x61\x63tions\x12\x45\n\tprincipal\x18\x03 \x01(\x0b\x32\x1b.cerbos.engine.v1.PrincipalB\n\xe2\x41\x01\x02\xbaH\x03\xc8\x01\x01R\tprincipal\x12\x46\n\x08resource\x18\x04 \x01(\x0b\x32\x1e.cerbos.request.v1.ResourceSetB\n\xe2\x41\x01\x02\xbaH\x03\xc8\x01\x01R\x08resource\x12\x63\n\x0cinclude_meta\x18\x05 \x01(\x08\x42@\x92\x41=2;Opt to receive request processing metadata in the response.R\x0bincludeMeta\x12;\n\x08\x61ux_data\x18\x06 \x01(\x0b\x32\x1a.cerbos.request.v1.AuxDataB\x04\xe2\x41\x01\x01R\x07\x61uxData:\x12\x92\x41\x0f\n\r2\x0bPDP Request\"\xb0\x08\n\x0bResourceSet\x12\x45\n\x04kind\x18\x01 \x01(\tB1\x92\x41 2\x0eResource kind.J\x0e\"album:object\"\xe2\x41\x01\x02\xbaH\x07\xc8\x01\x01r\x02\x10\x01R\x04kind\x12\xdd\x01\n\x0epolicy_version\x18\x02 \x01(\tB\xb5\x01\x92\x41\x99\x01\x32|The policy version to use to evaluate this request. If not specified, will default to the server-configured default version.J\t\"default\"\x8a\x01\r^[[:word:]]*$\xe2\x41\x01\x01\xbaH\x11r\x0f\x32\r^[[:word:]]*$R\rpolicyVersion\x12\xed\x02\n\tinstances\x18\x03 \x03(\x0b\x32-.cerbos.request.v1.ResourceSet.InstancesEntryB\x9f\x02\x92\x41\x8c\x02\x32mSet of resource instances to check. Each instance must be keyed by an application-specific unique identifier.J\x97\x01{\"XX125\":{\"attr\":{\"owner\":\"bugs_bunny\", \"public\": false, \"flagged\": false}}, \"XX225\":{\"attr\":{\"owner\":\"daffy_duck\", \"public\": true, \"flagged\": false}}}\xc8\x01\x01\xe2\x41\x01\x02\xbaH\x08\xc8\x01\x01\x9a\x01\x02\x08\x01R\tinstances\x12\x87\x02\n\x05scope\x18\x04 \x01(\tB\xf0\x01\x92\x41\xb2\x01\x32~A dot-separated scope that describes the hierarchy these resources belong to. This is used for determining policy inheritance.\x8a\x01/^([[:alnum:]][[:word:]\\-]*(\\.[[:word:]\\-]*)*)*$\xe2\x41\x01\x01\xbaH3r12/^([[:alnum:]][[:word:]\\-]*(\\.[[:word:]\\-]*)*)*$R\x05scope\x1a^\n\x0eInstancesEntry\x12\x10\n\x03key\x18\x01 \x01(\tR\x03key\x12\x36\n\x05value\x18\x02 \x01(\x0b\x32 .cerbos.request.v1.AttributesMapR\x05value:\x02\x38\x01: \x92\x41\x1d\n\x1b\x32\x19Set of resources to check\"\xc1\x02\n\rAttributesMap\x12\xa9\x01\n\x04\x61ttr\x18\x01 \x03(\x0b\x32*.cerbos.request.v1.AttributesMap.AttrEntryBi\x92\x41\x66\x32\x64Key-value pairs of contextual data about this instance that should be used during policy evaluation.R\x04\x61ttr\x1aO\n\tAttrEntry\x12\x10\n\x03key\x18\x01 \x01(\tR\x03key\x12,\n\x05value\x18\x02 \x01(\x0b\x32\x16.google.protobuf.ValueR\x05value:\x02\x38\x01:3\x92\x41\x30\n.2,Unique identifier for the resource instance.\"\xe7\x06\n\x19\x43heckResourceBatchRequest\x12\x96\x01\n\nrequest_id\x18\x01 \x01(\tBw\x92\x41t2JOptional application-specific ID useful for correlating logs for analysis.J&\"c2db17b8-4f9f-4fb1-acfd-9162a02be42b\"R\trequestId\x12\x45\n\tprincipal\x18\x02 \x01(\x0b\x32\x1b.cerbos.engine.v1.PrincipalB\n\xe2\x41\x01\x02\xbaH\x03\xc8\x01\x01R\tprincipal\x12\xc0\x02\n\tresources\x18\x03 \x03(\x0b\x32\x37.cerbos.request.v1.CheckResourceBatchRequest.BatchEntryB\xe8\x01\x92\x41\xd5\x01\x32\x1eList of resources and actions.J\xac\x01[{\"actions\":[\"view\",\"comment\"], \"resource\":{\"kind\":\"album:object\",\"policyVersion\":\"default\",\"id\":\"XX125\",\"attr\":{\"owner\":\"bugs_bunny\", \"public\": false, \"flagged\": false}}}]\xa8\x01\x01\xb0\x01\x01\xe2\x41\x01\x02\xbaH\x08\xc8\x01\x01\x92\x01\x02\x08\x01R\tresources\x12\x35\n\x08\x61ux_data\x18\x04 \x01(\x0b\x32\x1a.cerbos.request.v1.AuxDataR\x07\x61uxData\x1a\xdb\x01\n\nBatchEntry\x12\x88\x01\n\x07\x61\x63tions\x18\x01 \x03(\tBn\x92\x41T20List of actions being performed on the resource.J\x1a[\"view:public\", \"comment\"]\xa8\x01\x01\xb0\x01\x01\xe2\x41\x01\x02\xbaH\x10\xc8\x01\x01\x92\x01\n\x08\x01\x18\x01\"\x04r\x02\x10\x01R\x07\x61\x63tions\x12\x42\n\x08resource\x18\x02 \x01(\x0b\x32\x1a.cerbos.engine.v1.ResourceB\n\xe2\x41\x01\x02\xbaH\x03\xc8\x01\x01R\x08resource:\x12\x92\x41\x0f\n\r2\x0bPDP Request\"\xcb\x07\n\x15\x43heckResourcesRequest\x12\x96\x01\n\nrequest_id\x18\x01 \x01(\tBw\x92\x41t2JOptional application-specific ID useful for correlating logs for analysis.J&\"c2db17b8-4f9f-4fb1-acfd-9162a02be42b\"R\trequestId\x12X\n\x0cinclude_meta\x18\x02 \x01(\x08\x42\x35\x92\x41\x32\x32\x30\x41\x64\x64 request processing metadata to the response.R\x0bincludeMeta\x12\x45\n\tprincipal\x18\x03 \x01(\x0b\x32\x1b.cerbos.engine.v1.PrincipalB\n\xe2\x41\x01\x02\xbaH\x03\xc8\x01\x01R\tprincipal\x12\xbf\x02\n\tresources\x18\x04 \x03(\x0b\x32\x36.cerbos.request.v1.CheckResourcesRequest.ResourceEntryB\xe8\x01\x92\x41\xd5\x01\x32\x1eList of resources and actions.J\xac\x01[{\"actions\":[\"view\",\"comment\"], \"resource\":{\"kind\":\"album:object\",\"policyVersion\":\"default\",\"id\":\"XX125\",\"attr\":{\"owner\":\"bugs_bunny\", \"public\": false, \"flagged\": false}}}]\xa8\x01\x01\xb0\x01\x01\xe2\x41\x01\x02\xbaH\x08\xc8\x01\x01\x92\x01\x02\x08\x01R\tresources\x12\x35\n\x08\x61ux_data\x18\x05 \x01(\x0b\x32\x1a.cerbos.request.v1.AuxDataR\x07\x61uxData\x1a\xde\x01\n\rResourceEntry\x12\x88\x01\n\x07\x61\x63tions\x18\x01 \x03(\tBn\x92\x41T20List of actions being performed on the resource.J\x1a[\"view:public\", \"comment\"]\xa8\x01\x01\xb0\x01\x01\xe2\x41\x01\x02\xbaH\x10\xc8\x01\x01\x92\x01\n\x08\x01\x18\x01\"\x04r\x02\x10\x01R\x07\x61\x63tions\x12\x42\n\x08resource\x18\x02 \x01(\x0b\x32\x1a.cerbos.engine.v1.ResourceB\n\xe2\x41\x01\x02\xbaH\x03\xc8\x01\x01R\x08resource:\x1e\x92\x41\x1b\n\x19\x32\x17\x43heck resources request\"\xb3\x07\n\x07\x41uxData\x12\x30\n\x03jwt\x18\x01 \x01(\x0b\x32\x1e.cerbos.request.v1.AuxData.JWTR\x03jwt\x1a\xb1\x06\n\x03JWT\x12\xc8\x04\n\x05token\x18\x01 \x01(\tB\xb1\x04\x92\x41\x9f\x04\x32\x1dJWT from the original requestJ\xc9\x03\"eyJhbGciOiJFUzM4NCIsImtpZCI6IjE5TGZaYXRFZGc4M1lOYzVyMjNndU1KcXJuND0iLCJ0eXAiOiJKV1QifQ.eyJhdWQiOlsiY2VyYm9zLWp3dC10ZXN0cyJdLCJjdXN0b21BcnJheSI6WyJBIiwiQiIsIkMiXSwiY3VzdG9tSW50Ijo0MiwiY3VzdG9tTWFwIjp7IkEiOiJBQSIsIkIiOiJCQiIsIkMiOiJDQyJ9LCJjdXN0b21TdHJpbmciOiJmb29iYXIiLCJleHAiOjE5NDk5MzQwMzksImlzcyI6ImNlcmJvcy10ZXN0LXN1aXRlIn0.WN_tOScSpd_EI-P5EI1YlagxEgExSfBjAtcrgcF6lyWj1lGpR_GKx9goZEp2p_t5AVWXN_bjz_sMUmJdJa4cVd55Qm1miR-FKu6oNRHnSEWdMFmnArwPw-YDJWfylLFX\"\x82\x03\x1a\n\x14x-example-show-value\x12\x02 \x00\x82\x03\x14\n\x0ex-fill-example\x12\x02 \x00\xe2\x41\x01\x02\xbaH\x07\xc8\x01\x01r\x02\x10\x01R\x05token\x12\xb8\x01\n\nkey_set_id\x18\x02 \x01(\tB\x99\x01\x92\x41\x95\x01\x32RKey ID to use when decoding the token (defined in the Cerbos server configuration)J\x0b\"my-keyset\"\x82\x03\x1a\n\x14x-example-show-value\x12\x02 \x00\x82\x03\x14\n\x0ex-fill-example\x12\x02 \x00R\x08keySetId:$\x92\x41!\n\x1f\x32\x1dJWT from the original request:B\x92\x41?\n=2;Structured auxiliary data useful for evaluating the request\"/\n\x11ServerInfoRequest:\x1a\x92\x41\x17\n\x15\x32\x13Server info requestBs\n\x19\x64\x65v.cerbos.api.v1.requestZ>github.com/cerbos/cerbos/api/genpb/cerbos/request/v1;requestv1\xaa\x02\x15\x43\x65rbos.Api.V1.Requestb\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool
pool.add_serialized_file(descriptor_data)

module Cerbos::Protobuf::Cerbos
  module Request
    module V1
      PlanResourcesRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.PlanResourcesRequest").msgclass
      CheckResourceSetRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.CheckResourceSetRequest").msgclass
      ResourceSet = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.ResourceSet").msgclass
      AttributesMap = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.AttributesMap").msgclass
      CheckResourceBatchRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.CheckResourceBatchRequest").msgclass
      CheckResourceBatchRequest::BatchEntry = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.CheckResourceBatchRequest.BatchEntry").msgclass
      CheckResourcesRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.CheckResourcesRequest").msgclass
      CheckResourcesRequest::ResourceEntry = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.CheckResourcesRequest.ResourceEntry").msgclass
      AuxData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.AuxData").msgclass
      AuxData::JWT = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.AuxData.JWT").msgclass
      ServerInfoRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("cerbos.request.v1.ServerInfoRequest").msgclass
    end
  end
end
