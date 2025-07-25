# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        class ChangeDetails
          # Metadata describing the uploader who made a change to a store.
          class Uploader
            # The name of the uploader.
            #
            # @return [String]
            attr_reader :name

            # User-defined metadata about the origin of the change.
            #
            # @return [Cerbos::Input::Attributes]
            attr_reader :metadata

            # Specify metadata describing the uploader who made a change to a store.
            #
            # @param name [String] the name of the uploader.
            # @param metadata [Cerbos::Input::Attributes, Hash] user-defined metadata about the origin of the change.
            def initialize(name: "", metadata: {})
              @name = name
              @metadata = Cerbos::Input.coerce_required(metadata, Cerbos::Input::Attributes)
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::ChangeDetails::Uploader.new(name:, metadata: metadata.to_protobuf)
            end
          end
        end
      end
    end
  end
end
