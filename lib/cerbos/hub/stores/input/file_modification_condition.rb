# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        # A condition that must be met to make a file modification.
        class FileModificationCondition
          # Only modify files if the store version is equal to the provided value.
          #
          # @return [Integer]
          attr_reader :store_version_must_equal

          # Specify a condition that must be met to make a file modification.
          #
          # @param store_version_must_equal [Integer] only modify files if the store version is equal to the provided value.
          def initialize(store_version_must_equal:)
            @store_version_must_equal = store_version_must_equal
          end

          # @private
          def to_protobuf_modify_files
            Protobuf::Cerbos::Cloud::Store::V1::ModifyFilesRequest::Condition.new(store_version_must_equal:)
          end

          # @private
          def to_protobuf_replace_files
            Protobuf::Cerbos::Cloud::Store::V1::ReplaceFilesRequest::Condition.new(store_version_must_equal:)
          end
        end
      end
    end
  end
end
