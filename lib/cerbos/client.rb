# frozen_string_literal: true

module Cerbos
  # A client for interacting with the Cerbos policy decision point (PDP) server over gRPC.
  #
  # An instance of the client may be shared between threads.
  # However, due to [an issue in the underlying `grpc` gem](https://github.com/grpc/grpc/issues/8798), it's not possible to use the client before and after process forks.
  # If your application runs on a forking webserver (for example, Puma in clustered mode), then you'll need to ensure that you only create client instances in the child (worker) processes.
  class Client
    # Create a client for interacting with the Cerbos PDP server over gRPC.
    #
    # @param target [String] Cerbos PDP server address (`"host"`, `"host:port"`, or `"unix:/path/to/socket"`).
    # @param tls [TLS, MutualTLS, false] gRPC connection encryption settings (`false` for plaintext).
    # @param grpc_channel_args [Hash{String, Symbol => String, Integer}] low-level settings for the gRPC channel (see [available keys in the gRPC documentation](https://grpc.github.io/grpc/core/group__grpc__arg__keys.html)).
    # @param on_validation_error [:return, :raise, #call] action to take when input fails schema validation (`:return` to return the validation errors in the response, `:raise` to raise {Error::ValidationFailed}, or a callback to invoke).
    # @param playground_instance [String, nil] identifier of the playground instance to use when prototyping against the hosted demo PDP.
    # @param timeout [Numeric, nil] timeout for gRPC calls, in seconds (`nil` to never time out).
    #
    # @example Connect via TCP with no encryption
    #   client = Cerbos::Client.new("localhost:3593", tls: false)
    #
    # @example Connect via a Unix socket with no encryption
    #   client = Cerbos::Client.new("unix:/var/run/cerbos.grpc.sock", tls: false)
    #
    # @example Connect to the hosted demo PDP to experiment [in the playground](https://play.cerbos.dev)
    #   client = Cerbos::Client.new("demo-pdp.cerbos.cloud", tls: Cerbos::TLS.new, playground_instance: "gE623b0180QlsG5a4QIN6UOZ6f3iSFW2")
    #
    # @example Raise an error when input fails schema validation
    #   client = Cerbos::Client.new("localhost:3593", tls: false, on_validation_error: :raise)
    #
    # @example Invoke a callback when input fails schema validation
    #   client = Cerbos::Client.new("localhost:3593", tls: false, on_validation_error: ->(validation_errors) { do_something_with validation_errors })
    def initialize(target, tls:, grpc_channel_args: {}, on_validation_error: :return, playground_instance: nil, timeout: nil)
      @on_validation_error = on_validation_error

      handle_errors do
        credentials = tls ? tls.to_channel_credentials : :this_channel_is_insecure

        unless playground_instance.nil?
          credentials = credentials.compose(GRPC::Core::CallCredentials.new(->(*) { {"playground-instance" => playground_instance} }))
        end

        channel_args = grpc_channel_args.merge({
          "grpc.primary_user_agent" => [grpc_channel_args["grpc.primary_user_agent"], "cerbos-sdk-ruby/#{VERSION}"].compact.join(" ")
        })

        @cerbos_service = Protobuf::Cerbos::Svc::V1::CerbosService::Stub.new(
          target,
          credentials,
          channel_args: channel_args,
          timeout: timeout
        )
      end
    end

    # Check if a principal is allowed to perform an action on a resource.
    #
    # @param principal [Input::Principal, Hash] the principal to check.
    # @param resource [Input::Resource, Hash] the resource to check.
    # @param action [String] the action to check.
    # @param aux_data [Input::AuxData, Hash, nil] auxiliary data.
    # @param request_id [String] identifier for tracing the request.
    #
    # @return [Boolean]
    #
    # @example
    #   client.allow?(
    #     principal: {id: "user@example.com", roles: ["USER"]},
    #     resource: {kind: "document", id: "1"},
    #     action: "view"
    #   ) # => true
    def allow?(principal:, resource:, action:, aux_data: nil, request_id: SecureRandom.uuid)
      check_resource(
        principal: principal,
        resource: resource,
        actions: [action],
        aux_data: aux_data,
        request_id: request_id
      ).allow?(action)
    end

    # Check a principal's permissions on a resource.
    #
    # @param principal [Input::Principal, Hash] the principal to check.
    # @param resource [Input::Resource, Hash] the resource to check.
    # @param actions [Array<String>] the actions to check.
    # @param aux_data [Input::AuxData, Hash, nil] auxiliary data.
    # @param include_metadata [Boolean] `true` to include additional metadata ({Output::CheckResources::Result::Metadata}) in the results.
    # @param request_id [String] identifier for tracing the request.
    #
    # @return [Output::CheckResources::Result]
    #
    # @example
    #   decision = client.check_resource(
    #     principal: {id: "user@example.com", roles: ["USER"]},
    #     resource: {kind: "document", id: "1"},
    #     actions: ["view", "edit"]
    #   )
    #
    #   decision.allow?("view") # => true
    def check_resource(principal:, resource:, actions:, aux_data: nil, include_metadata: false, request_id: SecureRandom.uuid)
      handle_errors do
        check_resources(
          principal: principal,
          resources: [Input::ResourceCheck.new(resource: resource, actions: actions)],
          aux_data: aux_data,
          include_metadata: include_metadata,
          request_id: request_id
        ).find_result(resource)
      end
    end

    # Check a principal's permissions on a set of resources.
    #
    # @param principal [Input::Principal, Hash] the principal to check.
    # @param resources [Array<Input::ResourceCheck, Hash>] the resources and actions to check.
    # @param aux_data [Input::AuxData, Hash, nil] auxiliary data.
    # @param include_metadata [Boolean] `true` to include additional metadata ({Output::CheckResources::Result::Metadata}) in the results.
    # @param request_id [String] identifier for tracing the request.
    #
    # @return [Output::CheckResources]
    #
    # @example
    #   decision = client.check_resources(
    #     principal: {id: "user@example.com", roles: ["USER"]},
    #     resources: [
    #       {
    #         resource: {kind: "document", id: "1"},
    #         actions: ["view", "edit"]
    #       },
    #       {
    #         resource: {kind: "image", id: "1"},
    #         actions: ["delete"]
    #       }
    #     ]
    #   )
    #
    #   decision.allow?(resource: {kind: "document", id: "1"}, action: "view") # => true
    def check_resources(principal:, resources:, aux_data: nil, include_metadata: false, request_id: SecureRandom.uuid)
      handle_errors do
        request = Protobuf::Cerbos::Request::V1::CheckResourcesRequest.new(
          principal: Input.coerce_required(principal, Input::Principal).to_protobuf,
          resources: Input.coerce_array(resources, Input::ResourceCheck).map(&:to_protobuf),
          aux_data: Input.coerce_optional(aux_data, Input::AuxData)&.to_protobuf,
          include_meta: include_metadata,
          request_id: request_id
        )

        response = perform_request(@cerbos_service, :check_resources, request)

        Output::CheckResources.from_protobuf(response).tap do |output|
          handle_validation_errors output
        end
      end
    end

    # Produce a query plan that can be used to obtain a list of resources on which a principal is allowed to perform a particular action.
    #
    # @param principal [Input::Principal, Hash] the principal for whom to plan.
    # @param resource [Input::ResourceQuery, Hash] partial details of the resources for which to plan.
    # @param action [String] the action for which to plan.
    # @param aux_data [Input::AuxData, Hash, nil] auxiliary data.
    # @param include_metadata [Boolean] `true` to include additional metadata ({Output::CheckResources::Result::Metadata}) in the results.
    # @param request_id [String] identifier for tracing the request.
    #
    # @return [Output::PlanResources]
    #
    # @example
    #   plan = client.plan_resources(
    #     principal: {id: "user@example.com", roles: ["USER"]},
    #     resource: {kind: "document"},
    #     action: "view"
    #   )
    #
    #   plan.conditional? # => true
    #   plan.condition # => #<Cerbos::Output::PlanResources::Expression ...>
    def plan_resources(principal:, resource:, action:, aux_data: nil, include_metadata: false, request_id: SecureRandom.uuid)
      handle_errors do
        request = Protobuf::Cerbos::Request::V1::PlanResourcesRequest.new(
          principal: Input.coerce_required(principal, Input::Principal).to_protobuf,
          resource: Input.coerce_required(resource, Input::ResourceQuery).to_protobuf,
          action: action,
          aux_data: Input.coerce_optional(aux_data, Input::AuxData)&.to_protobuf,
          include_meta: include_metadata,
          request_id: request_id
        )

        response = perform_request(@cerbos_service, :plan_resources, request)

        Output::PlanResources.from_protobuf(response)
      end
    end

    # Retrieve information about the Cerbos PDP server.
    #
    # @return [Output::ServerInfo]
    def server_info
      handle_errors do
        request = Protobuf::Cerbos::Request::V1::ServerInfoRequest.new

        response = perform_request(@cerbos_service, :server_info, request)

        Output::ServerInfo.from_protobuf(response)
      end
    end

    private

    def handle_errors
      yield
    rescue Error
      raise
    rescue ArgumentError, TypeError => error
      raise Error::InvalidArgument.new(details: error.message)
    rescue GRPC::BadStatus => error
      raise Error::NotOK.from_grpc_bad_status(error)
    rescue => error
      raise Error, error.message
    end

    def handle_validation_errors(output)
      return if @on_validation_error == :return

      validation_errors = output.results.flat_map(&:validation_errors)
      return if validation_errors.empty?

      raise Error::ValidationFailed.new(validation_errors) if @on_validation_error == :raise

      @on_validation_error.call validation_errors
    end

    def perform_request(service, rpc, request)
      service.public_send(rpc, request)
    end
  end
end
