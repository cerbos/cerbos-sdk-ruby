# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        class FileOperation
          include AbstractClass

          class AddOrUpdate < FileOperation
            attr_reader :file

            def initialize(file:)
              @file = file
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::FileOp.new(add_or_update: file.to_protobuf)
            end
          end

          class Delete < FileOperation
            attr_reader :path

            def initialize(path:)
              @path = path
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::FileOp.new(delete: path)
            end
          end

          def self.from_h(**file_operation)
            case file_operation
            in add_or_update: file, **nil
              AddOrUpdate.new(file:)
            in delete: path, **nil
              Delete.new(path:)
            end
          end
        end
      end
    end
  end
end
