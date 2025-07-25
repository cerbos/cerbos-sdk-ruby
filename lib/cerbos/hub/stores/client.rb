# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      class Client
        def initialize(client_id:, client_secret:, target: "api.cerbos.cloud:443", grpc_channel_args: {}, grpc_metadata: {}, timeout: nil)
          @service = Service.new(
            client_id:,
            client_secret:,
            stub: Protobuf::Cerbos::Cloud::Store::V1::CerbosStoreService::Stub,
            target:,
            grpc_channel_args:,
            grpc_metadata:,
            timeout:
          )
        end

        def get_files(store_id:, files:, grpc_metadata: {})
          Error.handle do
            request = Protobuf::Cerbos::Cloud::Store::V1::GetFilesRequest.new(store_id:, files:)

            response = @service.call(:get_files, request, grpc_metadata)

            Output::GetFiles.from_protobuf(response)
          end
        end

        def list_files(store_id:, filter: nil, grpc_metadata: {})
          Error.handle do
            request = Protobuf::Cerbos::Cloud::Store::V1::ListFilesRequest.new(
              store_id:,
              filter: Cerbos::Input.coerce_optional(filter, Input::FileFilter)&.to_protobuf
            )

            response = @service.call(:list_files, request, grpc_metadata)

            Output::ListFiles.from_protobuf(response)
          end
        end

        def modify_files(store_id:, operations:, condition: nil, change_details: nil, allow_unchanged: false, grpc_metadata: {})
          Error.handle do
            request = Protobuf::Cerbos::Cloud::Store::V1::ModifyFilesRequest.new(
              store_id:,
              operations: Cerbos::Input.coerce_array(operations, Input::FileOperation).map(&:to_protobuf),
              condition: Cerbos::Input.coerce_optional(condition, Input::FileModificationCondition)&.to_protobuf_modify_files,
              change_details: Cerbos::Input.coerce_optional(change_details, Input::ChangeDetails)&.to_protobuf
            )

            response = @service.call(:modify_files, request, grpc_metadata)

            Output::ModifyFiles.from_protobuf(response)
          end
        rescue Error::OperationDiscarded => error
          raise unless allow_unchanged

          Output::ModifyFiles.new(
            new_store_version: error.current_store_version,
            changed: false
          )
        end

        def replace_files(store_id:, files: nil, zipped_contents: nil, condition: nil, change_details: nil, allow_unchanged: false, grpc_metadata: {})
          Error.handle do
            request = Protobuf::Cerbos::Cloud::Store::V1::ReplaceFilesRequest.new(
              store_id:,
              files: files && Protobuf::Cerbos::Cloud::Store::V1::ReplaceFilesRequest::Files.new(files: files.map { |file| Cerbos::Input.coerce_required(file, File).to_protobuf }),
              zipped_contents:,
              condition: Cerbos::Input.coerce_optional(condition, Input::FileModificationCondition)&.to_protobuf_replace_files,
              change_details: Cerbos::Input.coerce_optional(change_details, Input::ChangeDetails)&.to_protobuf
            )

            response = @service.call(:replace_files, request, grpc_metadata)

            Output::ReplaceFiles.from_protobuf(response)
          end
        rescue Error::OperationDiscarded => error
          raise unless allow_unchanged

          Output::ReplaceFiles.new(
            new_store_version: error.current_store_version,
            ignored_files: error.ignored_files,
            changed: false
          )
        end
      end
    end
  end
end
