# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      # A client for interacting with policy stores in Cerbos Hub.
      class Client
        # Create a client for interacting with policy stores in Cerbos Hub.
        #
        # @param client_id [String] ID of the client credential to authenticate with Cerbos Hub.
        # @param client_secret [String] secret of the client credential to authenticate with Cerbos Hub.
        # @param target [String] address of the Cerbos Hub server.
        # @param grpc_channel_args [Hash{String, Symbol => String, Integer}] low-level settings for the gRPC channel (see [available keys in the gRPC documentation](https://grpc.github.io/grpc/core/group__grpc__arg__keys.html)).
        # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to every request to the PDP.
        # @param timeout [Numeric, nil] timeout for gRPC calls, in seconds (`nil` to never time out).
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

        # Get file contents from a policy store.
        #
        # @param store_id [String] ID of the store from which to get files.
        # @param files [Array<String>] paths of the files to retrieve.
        # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to the request.
        #
        # @return [Output::GetFiles]
        #
        # @example
        #   client.get_files(store_id: "MWPKEMFX3CK1", files: ["path/to/policy.yaml"])
        def get_files(store_id:, files:, grpc_metadata: {})
          Error.handle do
            request = Protobuf::Cerbos::Cloud::Store::V1::GetFilesRequest.new(store_id:, files:)

            response = @service.call(:get_files, request, grpc_metadata)

            Output::GetFiles.from_protobuf(response)
          end
        end

        # List file paths in a policy store.
        #
        # @param store_id [String] ID of the store from which to list files.
        # @param filter [Input::FileFilter, Hash, nil] filter to limit which files are listed.
        # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to the request.
        #
        # @return [Output::ListFiles]
        #
        # @example
        #   client.list_files(store_id: "MWPKEMFX3CK1")
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

        # Modify files in a policy store.
        #
        # This is a "patch" operation; files that aren't included in the request won't be modified.
        #
        # @param store_id [String] ID of the store in which to modify files.
        # @param operations [Array<Input::FileOperation, Hash>] modifications to make.
        # @param condition [Input::FileModificationCondition, Hash, nil] a condition that must be met for the modifications to be made.
        # @param change_details [Input::ChangeDetails, Hash, nil] metadata describing the change being made.
        # @param allow_unchanged [Boolean] allow modifications that do not change the state of the store. If `false` (the default), an {Error::OperationDiscarded} will be thrown if the modifications leave the store unchanged. If `true`, no error will be thrown and the current store version will be returned.
        # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to the request.
        #
        # @return [Output::ModifyFiles]
        #
        # @example
        #   client.modify_files(
        #     store_id: "MWPKEMFX3CK1",
        #     operations: [{add_or_update: {path: "policy.yaml", contents: ::File.binread("path/to/policy.yaml")}}]
        #   )
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

        # Replace files in a policy store.
        #
        # This is a "put" operation; files that aren't included in the request will be removed from the store.
        #
        # @param store_id [String] ID of the store in which to replace files.
        # @param files [Array<File, Hash>, nil] files to upload to the store. Mutually exclusive with `zipped_contents`.
        # @param zipped_contents [String, nil] binary-encoded string containing zipped files to upload to the store.
        # @param condition [Input::FileModificationCondition, Hash, nil] a condition that must be met for the replacement to be made.
        # @param change_details [Input::ChangeDetails, Hash, nil] metadata describing the change being made.
        # @param allow_unchanged [Boolean] allow replacements that do not change the state of the store. If `false` (the default), an {Error::OperationDiscarded} will be thrown if the contents match those of the store. If `true`, no error will be thrown and the current store version will be returned.
        # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to the request.
        #
        # @return [Output::ReplaceFiles]
        #
        # @example Upload individual files
        #   client.replace_files(
        #     store_id: "MWPKEMFX3CK1",
        #     files: [{path: "policy.yaml", contents: ::File.binread("path/to/policy.yaml")}]
        #   )
        #
        # @example Upload zipped files
        #   client.replace_files(
        #     store_id: "MWPKEMFX3CK1",
        #     zipped_contents: ::File.binread("path/to/policies.zip")
        #   )
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
