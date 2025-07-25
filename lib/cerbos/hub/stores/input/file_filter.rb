# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        class FileFilter
          attr_reader :path

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
