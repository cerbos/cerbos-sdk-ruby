# frozen_string_literal: true

module Cerbos
  # Base type for errors thrown by the `cerbos` gem.
  class Error < StandardError
    # Input failed schema validation.
    class ValidationFailed < Error
      # The validation errors that occurred.
      #
      # @return [Array<Output::CheckResources::Result::ValidationError>]
      attr_reader :validation_errors

      # @private
      def initialize(validation_errors)
        super "Input failed schema validation"

        @validation_errors = validation_errors
      end
    end

    # An error indicating an unsuccessful gRPC operation.
    class NotOK < Error
      # The gRPC status code.
      #
      # @return [Integer]
      #
      # @see https://grpc.github.io/grpc/core/md_doc_statuscodes.html Status codes in the gRPC documentation
      attr_reader :code

      # The gRPC error details.
      #
      # @return [String]
      attr_reader :details

      # The gRPC error metadata.
      #
      # @return [Hash]
      attr_reader :metadata

      # @private
      def self.from_grpc_bad_status(error)
        GRPC_BAD_STATUS_ERROR_CLASS.fetch(error.class, self).new(
          code: error.code,
          details: error.details,
          metadata: error.metadata
        )
      end

      # @private
      def initialize(code:, details:, metadata: {})
        super "gRPC error #{code}: #{details}"

        @code = code
        @details = details
        @metadata = metadata
      end
    end

    # The gRPC operation was cancelled.
    class Cancelled < NotOK
      def initialize(code: GRPC::Core::StatusCodes::CANCELLED, **args)
        super
      end
    end

    # The gRPC operation timed out.
    class DeadlineExceeded < NotOK
      def initialize(code: GRPC::Core::StatusCodes::DEADLINE_EXCEEDED, **args)
        super
      end
    end

    # The gRPC operation failed due to an internal error.
    class InternalError < NotOK
      def initialize(code: GRPC::Core::StatusCodes::INTERNAL, **args)
        super
      end
    end

    # The gRPC operation was rejected because an argument was invalid.
    class InvalidArgument < NotOK
      def initialize(code: GRPC::Core::StatusCodes::INVALID_ARGUMENT, **args)
        super
      end
    end

    # The gRPC operation failed because a resource has been exhausted.
    class ResourceExhausted < NotOK
      def initialize(code: GRPC::Core::StatusCodes::RESOURCE_EXHAUSTED, **args)
        super
      end
    end

    # The gRPC operation was rejected because it did not have valid authentication credentials.
    class Unauthenticated < NotOK
      def initialize(code: GRPC::Core::StatusCodes::UNAUTHENTICATED, **args)
        super
      end
    end

    # The gRPC operation failed because the service is unavailable.
    class Unavailable < NotOK
      def initialize(code: GRPC::Core::StatusCodes::UNAVAILABLE, **args)
        super
      end
    end

    # The gRPC operation is not supported.
    class Unimplemented < NotOK
      def initialize(code: GRPC::Core::StatusCodes::UNIMPLEMENTED, **args)
        super
      end
    end

    GRPC_BAD_STATUS_ERROR_CLASS = {
      GRPC::Cancelled => Cancelled,
      GRPC::DeadlineExceeded => DeadlineExceeded,
      GRPC::Internal => InternalError,
      GRPC::InvalidArgument => InvalidArgument,
      GRPC::ResourceExhausted => ResourceExhausted,
      GRPC::Unauthenticated => Unauthenticated,
      GRPC::Unavailable => Unavailable,
      GRPC::Unimplemented => Unimplemented
    }.freeze
    private_constant :GRPC_BAD_STATUS_ERROR_CLASS
  end
end
