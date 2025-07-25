# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        class ChangeDetails
          class Uploader
            # The name of the uploader.
            #
            # @return [String]
            attr_reader :name

            # User-defined metadata about the origin of the change.
            #
            # @return [Cerbos::Input::Attributes]
            attr_reader :metadata

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
