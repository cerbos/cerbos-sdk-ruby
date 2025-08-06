# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      # A file in a store.
      File = Output.new_class(:path, :contents) do
        # @!attribute [r] path
        #   The path of the file.
        #
        #   @return [String]

        # @!attribute [r] contents
        #   The contents of the file (with binary encoding).
        #
        #   @return [String]
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
