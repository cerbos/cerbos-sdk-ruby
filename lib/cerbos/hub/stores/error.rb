# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      # Namespace for errors specific to Cerbos Hub stores.
      module Error
        # Error thrown when attempting to modify a store that is connected to a Git repository.
        class CannotModifyGitConnectedStore < Cerbos::Error::NotOK
          # @private
          def initialize(error, _detail)
            super(code: error.code, details: error.details, metadata: error.metadata)
          end
        end

        # Error thrown when a store modification is rejected because the condition specified in the request wasn't met.
        class ConditionUnsatisfied < Cerbos::Error::NotOK
          # The current version of the store.
          attr_reader :current_store_version

          # @private
          def initialize(error, detail)
            super(code: error.code, details: error.details, metadata: error.metadata)
            @current_store_version = detail.current_store_version
          end
        end

        # Error thrown when {Client#replace_files} fails because the request didn't contain any usable files.
        class NoUsableFiles < Cerbos::Error::NotOK
          # Paths of files that were provided in the request but were ignored.
          #
          # Files with unexpected paths, for example hidden files, will be ignored.
          attr_reader :ignored_files

          # @private
          def initialize(error, detail)
            super(code: error.code, details: error.details, metadata: error.metadata)
            @ignored_files = detail.ignored_files
          end
        end

        # Error thrown when a store modification is aborted because it doesn't change the state of the store.
        #
        # Use the `allow_unchanged` request parameter to avoid throwing an error and return the current store version instead.
        class OperationDiscarded < Cerbos::Error::NotOK
          # The current version of the store.
          attr_reader :current_store_version

          # Paths of files that were provided in the request but were ignored.
          #
          # Files with unexpected paths, for example hidden files, will be ignored.
          attr_reader :ignored_files

          # @private
          def initialize(error, detail)
            super(code: error.code, details: error.details, metadata: error.metadata)
            @current_store_version = detail.current_store_version
            @ignored_files = detail.ignored_files
          end
        end

        # Error thrown when a store modification is rejected because it contains invalid files.
        class ValidationFailure < Cerbos::Error::NotOK
          # The validation failures.
          attr_reader :errors

          # @private
          def initialize(error, detail)
            super(code: error.code, details: error.details, metadata: error.metadata)
            @errors = detail.errors.map { |file_error| Output::FileError.from_protobuf(file_error) }
          end
        end

        # @private
        def self.handle
          Cerbos::Error.handle do
            yield
          rescue GRPC::BadStatus => error
            raise from_grpc_bad_status(error)
          end
        end

        # @private
        def self.from_grpc_bad_status(error)
          status = error.to_rpc_status
          return error if status.nil?

          status.details.each do |detail|
            ERROR_FROM_DETAILS.each do |detail_class, error_class|
              return error_class.new(error, detail.unpack(detail_class)) if detail.is(detail_class)
            end
          end

          error
        end

        ERROR_FROM_DETAILS = {
          Protobuf::Cerbos::Cloud::Store::V1::ErrDetailCannotModifyGitConnectedStore => CannotModifyGitConnectedStore,
          Protobuf::Cerbos::Cloud::Store::V1::ErrDetailConditionUnsatisfied => ConditionUnsatisfied,
          Protobuf::Cerbos::Cloud::Store::V1::ErrDetailNoUsableFiles => NoUsableFiles,
          Protobuf::Cerbos::Cloud::Store::V1::ErrDetailOperationDiscarded => OperationDiscarded,
          Protobuf::Cerbos::Cloud::Store::V1::ErrDetailValidationFailure => ValidationFailure
        }.freeze
        private_constant :ERROR_FROM_DETAILS
      end
    end
  end
end
