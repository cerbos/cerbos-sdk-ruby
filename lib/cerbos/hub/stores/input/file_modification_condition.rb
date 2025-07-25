# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        class FileModificationCondition
          attr_reader :store_version_must_equal

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
