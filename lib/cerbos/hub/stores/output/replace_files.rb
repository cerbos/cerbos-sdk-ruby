# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Output
        # The outcome of replacing files in a store.
        #
        # @see Client#replace_files
        ReplaceFiles = Cerbos::Output.new_class(:new_store_version, :ignored_files, :changed) do
          # @!attribute [r] new_store_version
          #   The new version of the store after the files were replaced.
          #
          #   If `allow_unchanged` was `true`, this will be the existing store version if no changes were made.
          #
          #   @return [Integer]

          # @!attribute [r] ignored_files
          #   Paths of files that were provided in the request but were ignored.
          #
          #   Files with unexpected paths, for example hidden files, will be ignored.
          #
          #   @return [Array<String>]

          # @!attribute [r] changed
          #   Whether any changes were made to the store contents.
          #
          #   This can only be `false` if `allow_unchanged` was `true`.
          #
          #   @return [Boolean]

          def self.from_protobuf(replace_files)
            new(
              new_store_version: replace_files.new_store_version,
              ignored_files: replace_files.ignored_files,
              changed: true
            )
          end
        end
      end
    end
  end
end
