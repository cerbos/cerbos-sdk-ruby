# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: cerbos/svc/v1/svc.proto for package 'cerbos.svc.v1'
# Original file comments:
# Copyright 2021-2025 Zenauth Ltd.
# SPDX-License-Identifier: Apache-2.0
#

require 'grpc'
require 'cerbos/protobuf/cerbos/svc/v1/svc_pb'

module Cerbos::Protobuf::Cerbos
  module Svc
    module V1
      module CerbosService
        class Service

          include ::GRPC::GenericService

          self.marshal_class_method = :encode
          self.unmarshal_class_method = :decode
          self.service_name = 'cerbos.svc.v1.CerbosService'

          rpc :CheckResourceSet, ::Cerbos::Protobuf::Cerbos::Request::V1::CheckResourceSetRequest, ::Cerbos::Protobuf::Cerbos::Response::V1::CheckResourceSetResponse
          rpc :CheckResourceBatch, ::Cerbos::Protobuf::Cerbos::Request::V1::CheckResourceBatchRequest, ::Cerbos::Protobuf::Cerbos::Response::V1::CheckResourceBatchResponse
          rpc :CheckResources, ::Cerbos::Protobuf::Cerbos::Request::V1::CheckResourcesRequest, ::Cerbos::Protobuf::Cerbos::Response::V1::CheckResourcesResponse
          rpc :ServerInfo, ::Cerbos::Protobuf::Cerbos::Request::V1::ServerInfoRequest, ::Cerbos::Protobuf::Cerbos::Response::V1::ServerInfoResponse
          rpc :PlanResources, ::Cerbos::Protobuf::Cerbos::Request::V1::PlanResourcesRequest, ::Cerbos::Protobuf::Cerbos::Response::V1::PlanResourcesResponse
        end

        Stub = Service.rpc_stub_class
      end
    end
  end
end
