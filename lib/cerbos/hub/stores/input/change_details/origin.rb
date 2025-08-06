# frozen_string_literal: true

module Cerbos
  module Hub
    module Stores
      module Input
        class ChangeDetails
          # Origin of a change that was made to a store.
          #
          # @abstract
          class Origin
            include AbstractClass

            # Details of a change made to a store when syncing it with a Git repository.
            class Git < Origin
              # The Git repository with which the store was synced.
              #
              # @return [String]
              attr_reader :repo

              # The Git ref with which the store was synced.
              #
              # @return [String]
              attr_reader :ref

              # The hash of the commit with which the store was synced.
              #
              # @return [String]
              attr_reader :hash

              # The message of the commit with which the store was synced.
              #
              # @return [String]
              attr_reader :message

              # The committer of the commit with which the store was synced.
              #
              # @return [String]
              attr_reader :committer

              # The commit date of the commit with which the store was synced.
              #
              # @return [Time]
              # @return [nil] if not provided
              attr_reader :commit_date

              # The author of the commit with which the store was synced.
              #
              # @return [String]
              attr_reader :author

              # The author date of the commit with which the store was synced.
              #
              # @return [Time]
              # @return [nil] if not provided
              attr_reader :author_date

              # Specify details of a change made to a store when syncing it with a Git repository.
              #
              # @param repo [String] the Git repository with which the store was synced.
              # @param ref [String] the Git ref with which the store was synced.
              # @param hash [String] the hash of the commit with which the store was synced.
              # @param message [String] the message of the commit with which the store was synced.
              # @param committer [String] the committer of the commit with which the store was synced.
              # @param commit_date [Time, nil] the commit date of the commit with which the store was synced.
              # @param author [String] the author of the commit with which the store was synced.
              # @param author_date [Time, nil] the author date of the commit with which the store was synced.
              def initialize(
                repo: "",
                ref: "",
                hash: "",
                message: "",
                committer: "",
                commit_date: nil,
                author: "",
                author_date: nil
              )
                @repo = repo
                @ref = ref
                @hash = hash
                @message = message
                @committer = committer
                @commit_date = commit_date
                @author = author
                @author_date = author_date
              end

              # @private
              def to_protobuf
                Protobuf::Cerbos::Cloud::Store::V1::ChangeDetails::Git.new(
                  repo:,
                  ref:,
                  hash:,
                  message:,
                  committer:,
                  commit_date: commit_date && Google::Protobuf::Timestamp.new.from_time(commit_date),
                  author:,
                  author_date: author_date && Google::Protobuf::Timestamp.new.from_time(author_date)
                )
              end
            end

            # Details of a change made to a store by an internal application.
            class Internal < Origin
              # The source of the change.
              #
              # @return [String]
              attr_reader :source

              # User-defined metadata about the origin of the change.
              #
              # @return [Cerbos::Input::Attributes]
              attr_reader :metadata

              # Specify details of a change made to a store by an internal application.
              #
              # @param source [String] the source of the change.
              # @param metadata [Cerbos::Input::Attributes, Hash] user-defined metadata about the origin of the change.
              def initialize(source: "", metadata: {})
                @source = source
                @metadata = Cerbos::Input.coerce_required(metadata, Cerbos::Input::Attributes)
              end

              # @private
              def to_protobuf
                Protobuf::Cerbos::Cloud::Store::V1::ChangeDetails::Internal.new(source:, metadata: metadata.to_protobuf)
              end
            end

            # @private
            def self.from_h(**origin)
              case origin
              in git:, **nil
                Git.new(**git)
              in internal:, **nil
                Internal.new(**internal)
              end
            end
          end
        end
      end
    end
  end
end
