# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        # A filter to match files when listing store contents.
        class FileFilter
          # Match files by path.
          #
          # @return [StringMatch]
          # @return [nil] if not provided
          attr_reader :path

          # Specify a filter to match files when listing store contents.
          #
          # @param path [StringMatch, Hash, nil] match files by path.
          def initialize(path: nil)
            @path = Cerbos::Input.coerce_optional(path, StringMatch)
          end

          # @private
          def to_protobuf
            Protobuf::Cerbos::Cloud::Store::V1::FileFilter.new(path: path&.to_protobuf)
          end
        end
      end
    end
  end
end
