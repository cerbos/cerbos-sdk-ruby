# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        class ChangeDetails
          # Description of the change.
          #
          # @return [String]
          attr_reader :description

          # Origin of the change.
          #
          # @return [Origin]
          # @return [nil] if not provided
          attr_reader :origin

          # Metadata describing the uploader who made the change.
          #
          # @return [Uploader]
          # @return [nil] if not provided
          attr_reader :uploader

          def initialize(description: "", origin: nil, uploader: nil)
            @description = description
            @origin = Cerbos::Input.coerce_optional(origin, Origin)
            @uploader = Cerbos::Input.coerce_optional(uploader, Uploader)
          end

          # @private
          def to_protobuf
            Protobuf::Cerbos::Cloud::Store::V1::ChangeDetails.new(
              description:,
              origin: origin&.to_protobuf,
              uploader: uploader&.to_protobuf
            )
          end
        end
      end
    end
  end
end

require_relative "change_details/origin"
require_relative "change_details/uploader"
