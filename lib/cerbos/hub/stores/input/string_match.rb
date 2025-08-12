# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        # Filter to match a string.
        #
        # @abstract
        class StringMatch
          include AbstractClass

          # Filter to match a string exactly.
          class Equals < StringMatch
            # The string to match.
            #
            # @return [String]
            attr_reader :value

            # Specify a filter to match a string exactly.
            #
            # @param value [String] the string to match.
            def initialize(value:)
              @value = value
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::StringMatch.new(equals: value)
            end
          end

          # Filter to match a string by a substring.
          class Contains < StringMatch
            # The substring to match.
            #
            # @return [String]
            attr_reader :value

            # Specify a filter to match a string by a substring.
            #
            # @param value [String] the substring to match.
            def initialize(value:)
              @value = value
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::StringMatch.new(contains: value)
            end
          end

          # Filter to match a string from a list.
          class In < StringMatch
            # The strings to match.
            #
            # @return [Array<String>]
            attr_reader :values

            # Specify a filter to match a string from a list.
            #
            # @param values [Array<String>] the strings to match.
            def initialize(values:)
              @values = values
            end

            # @private
            def to_protobuf
              Protobuf::Cerbos::Cloud::Store::V1::StringMatch.new(in: Protobuf::Cerbos::Cloud::Store::V1::StringMatch::InList.new(values:))
            end
          end

          # @private
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
