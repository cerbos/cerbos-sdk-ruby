# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        class StringMatch
          include AbstractClass

          class Equals < StringMatch
            attr_reader :value

            def initialize(value:)
              @value = value
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::StringMatch.new(equals: value)
            end
          end

          class Contains < StringMatch
            attr_reader :value

            def initialize(value:)
              @value = value
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::StringMatch.new(contains: value)
            end
          end

          class In < StringMatch
            attr_reader :values

            def initialize(values:)
              @values = values
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::StringMatch.new(in: Protobuf::Cerbos::Cloud::Store::V1::StringMatch::InList.new(values:))
            end
          end

          def self.from_h(**string_match)
            case string_match
            in equals: value, **nil
              Equals.new(value:)
            in contains: value, **nil
              Contains.new(value:)
            in in: values, **nil
              In.new(values:)
            end
          end
        end
      end
    end
  end
end
