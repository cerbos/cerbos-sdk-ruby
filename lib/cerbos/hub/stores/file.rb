# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      File = Output.new_class(:path, :contents) do
        def self.from_protobuf(file)
          new(path: file.path, contents: file.contents)
        end

        # @private
        def to_protobuf
          Protobuf::Cerbos::Cloud::Store::V1::File.new(path:, contents:)
        end
      end
    end
  end
end
