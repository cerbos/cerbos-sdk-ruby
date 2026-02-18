# frozen_string_literal: true

module Cerbos
  module Input
    # Metadata attached to a request.
    #
    # Requires the Cerbos policy decision point server to be at least v0.51.
    # This information will be captured in the audit logs if audit logging is enabled in the policy decision point server.
    class RequestContext
      # User-defined metadata.
      #
      # @return [Attributes]
      attr_reader :annotations

      # Specify metadata to attach to a request.
      #
      # @param annotations [Attributes, Hash] user-defined metadata.
      def initialize(annotations: {})
        @annotations = Input.coerce_required(annotations, Attributes)
      end

      # @private
      def to_protobuf
        Protobuf::Cerbos::Audit::V1::RequestContext.new(annotations: annotations.to_protobuf)
      end
    end
  end
end
