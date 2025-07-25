# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Output
        ModifyFiles = Cerbos::Output.new_class(:new_store_version, :changed) do
          # @!attribute [r] new_store_version
          #   The new version of the store after the files were replaced.
          #
          #   If `allow_unchanged` was `true`, this will be the existing store version if no changes were made.
          #
          #   @return [Integer]

          # @!attribute [r] changed
          #   Whether any changes were made to the store contents.
          #
          #   This can only be `false` if `allow_unchanged` was `true`.
          #
          #   @return [Boolean]

          def self.from_protobuf(modify_files)
            new(
              new_store_version: modify_files.new_store_version,
              changed: true
            )
          end
        end
      end
    end
  end
end
