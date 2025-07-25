# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        # An operation modifying a file in a store.
        #
        # @abstract
        class FileOperation
          include AbstractClass

          # Add or update a file.
          class AddOrUpdate < FileOperation
            # The file to add or update.
            #
            # @return [File]
            attr_reader :file

            # Specify a file to add or update.
            #
            # @param file [File, Hash] the file to add or update.
            def initialize(file:)
              @file = Cerbos::Input.coerce_required(file, File)
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::FileOp.new(add_or_update: file.to_protobuf)
            end
          end

          # Delete a file.
          class Delete < FileOperation
            # Path of the file to delete.
            #
            # @return [String]
            attr_reader :path

            # Specify a file to delete.
            #
            # @param path [String] path of the file to delete.
            def initialize(path:)
              @path = path
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::FileOp.new(delete: path)
            end
          end

          # @private
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
