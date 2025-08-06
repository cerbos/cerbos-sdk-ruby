# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Output
        # The outcome of getting files from a store.
        #
        # @see Client#get_files
        GetFiles = Cerbos::Output.new_class(:store_version, :files) do
          # @!attribute [r] store_version
          #   The current version of the store.
          #
          #   @return [Integer]

          # @!attribute [r] files
          #   Paths of the files that were found in the store.
          #
          #   @return [Array<File>]

          def self.from_protobuf(get_files)
            new(
              store_version: get_files.store_version,
              files: get_files.files.map { |file| File.from_protobuf(file) }
            )
          end
        end
      end
    end
  end
end
