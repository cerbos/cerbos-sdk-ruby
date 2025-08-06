# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Output
        # The outcome of listing files in a store.
        #
        # @see Client#list_files
        ListFiles = Cerbos::Output.new_class(:store_version, :files) do
          # @!attribute [r] store_version
          #   The current version of the store.
          #
          #   @return [Integer]

          # @!attribute [r] files
          #   Paths of the files that were found in the store.
          #
          #   @return [Array<String>]

          def self.from_protobuf(list_files)
            new(
              store_version: list_files.store_version,
              files: list_files.files
            )
          end
        end
      end
    end
  end
end
