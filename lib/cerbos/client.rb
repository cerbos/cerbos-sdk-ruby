# frozen_string_literal: true

module Cerbos
  # A client for interacting with the Cerbos policy decision point (PDP) server over gRPC.
  #
  # An instance of the client may be shared between threads.
  #
  # Due to [a limitation in the underlying `grpc` gem](https://github.com/grpc/grpc/issues/8798), creating a client instance before a process fork is [only (experimentally) supported on Linux](https://github.com/grpc/grpc/pull/33430) and requires you to
  # - have at least v1.57.0 of the `grpc` gem installed,
  # - set the `GRPC_ENABLE_FORK_SUPPORT` environment variable to `1`,
  # - call `GRPC.prefork` before forking,
  # - call `GRPC.postfork_parent` in the parent process after forking, and
  # - call `GRPC.postfork_child` in the child processes after forking.
  #
  # Otherwise, if your application runs on a forking webserver (for example, Puma in clustered mode), then you'll need to ensure that you only create client instances in the child (worker) processes.
  class Client
    # Create a client for interacting with the Cerbos PDP server over gRPC.
    #
    # @param target [String] Cerbos PDP server address (`"host"`, `"host:port"`, or `"unix:/path/to/socket"`).
    # @param tls [TLS, MutualTLS, false] gRPC connection encryption settings (`false` for plaintext).
    # @param grpc_channel_args [Hash{String, Symbol => String, Integer}] low-level settings for the gRPC channel (see [available keys in the gRPC documentation](https://grpc.github.io/grpc/core/group__grpc__arg__keys.html)).
    # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to every request to the PDP.
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
    def initialize(target, tls:, grpc_channel_args: {}, grpc_metadata: {}, on_validation_error: :return, playground_instance: nil, timeout: nil)
      @on_validation_error = on_validation_error

      Error.handle do
        credentials = tls ? tls.to_channel_credentials : :this_channel_is_insecure

        unless playground_instance.nil?
          credentials = credentials.compose(GRPC::Core::CallCredentials.new(->(*) { {"playground-instance" => playground_instance} }))
        end

        @cerbos_service = Service.new(
          stub: Protobuf::Cerbos::Svc::V1::CerbosService::Stub,
          target:,
          credentials:,
          grpc_channel_args:,
          grpc_metadata:,
          timeout:
        )

        @health_service = Service.new(
          stub: Protobuf::Grpc::Health::V1::Health::Stub,
          target:,
          credentials:,
          grpc_channel_args:,
          grpc_metadata:,
          timeout:
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
    # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to the request.
    #
    # @return [Boolean]
    #
    # @example
    #   client.allow?(
    #     principal: {id: "user@example.com", roles: ["USER"]},
    #     resource: {kind: "document", id: "1"},
    #     action: "view"
    #   ) # => true
    def allow?(principal:, resource:, action:, aux_data: nil, request_id: SecureRandom.uuid, grpc_metadata: {})
      check_resource(
        principal: principal,
        resource: resource,
        actions: [action],
        aux_data: aux_data,
        request_id: request_id,
        grpc_metadata: grpc_metadata
      ).allow?(action)
    end

    # Check the health of a service provided by the policy decision point server.
    #
    # @param service ["cerbos.svc.v1.CerbosService", "cerbos.svc.v1.CerbosAdminService"] the service to check.
    # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to the request.
    #
    # @return [Output::HealthCheck]
    #
    # @example
    #   cerbos_api = client.check_health
    #   cerbos_api.status # => :SERVING
    #
    #   admin_api = client.check_health(service: "cerbos.svc.v1.CerbosAdminService")
    #   admin_api.status # => :DISABLED
    def check_health(service: "cerbos.svc.v1.CerbosService", grpc_metadata: {})
      Error.handle do
        request = Protobuf::Grpc::Health::V1::HealthCheckRequest.new(service: service)

        response = @health_service.call(:check, request, grpc_metadata)

        Output::HealthCheck.from_protobuf(response)
      end
    rescue Error::NotFound
      return Output::HealthCheck.new(status: :DISABLED) if service == "cerbos.svc.v1.CerbosAdminService"

      raise
    end

    # Check a principal's permissions on a resource.
    #
    # @param principal [Input::Principal, Hash] the principal to check.
    # @param resource [Input::Resource, Hash] the resource to check.
    # @param actions [Array<String>] the actions to check.
    # @param aux_data [Input::AuxData, Hash, nil] auxiliary data.
    # @param include_metadata [Boolean] `true` to include additional metadata ({Output::CheckResources::Result::Metadata}) in the results.
    # @param request_id [String] identifier for tracing the request.
    # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to the request.
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
    def check_resource(principal:, resource:, actions:, aux_data: nil, include_metadata: false, request_id: SecureRandom.uuid, grpc_metadata: {})
      Error.handle do
        check_resources(
          principal: principal,
          resources: [Input::ResourceCheck.new(resource: resource, actions: actions)],
          aux_data: aux_data,
          include_metadata: include_metadata,
          request_id: request_id,
          grpc_metadata: grpc_metadata
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
    # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to the request.
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
    def check_resources(principal:, resources:, aux_data: nil, include_metadata: false, request_id: SecureRandom.uuid, grpc_metadata: {})
      Error.handle do
        request = Protobuf::Cerbos::Request::V1::CheckResourcesRequest.new(
          principal: Input.coerce_required(principal, Input::Principal).to_protobuf,
          resources: Input.coerce_array(resources, Input::ResourceCheck).map(&:to_protobuf),
          aux_data: Input.coerce_optional(aux_data, Input::AuxData)&.to_protobuf,
          include_meta: include_metadata,
          request_id: request_id
        )

        response = @cerbos_service.call(:check_resources, request, grpc_metadata)

        Output::CheckResources.from_protobuf(response).tap do |output|
          handle_validation_errors output
        end
      end
    end

    # Produce a query plan that can be used to obtain a list of resources on which a principal is allowed to perform a particular action.
    #
    # @param principal [Input::Principal, Hash] the principal for whom to plan.
    # @param resource [Input::ResourceQuery, Hash] partial details of the resources for which to plan.
    # @param action [String] deprecated (use `actions` instead).
    # @param actions [Array<String>] the actions for which to plan (requires a policy decision point server running Cerbos v0.44+).
    # @param aux_data [Input::AuxData, Hash, nil] auxiliary data.
    # @param include_metadata [Boolean] `true` to include additional metadata ({Output::CheckResources::Result::Metadata}) in the results.
    # @param request_id [String] identifier for tracing the request.
    # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to the request.
    #
    # @return [Output::PlanResources]
    #
    # @example
    #   plan = client.plan_resources(
    #     principal: {id: "user@example.com", roles: ["USER"]},
    #     resource: {kind: "document"},
    #     actions: ["view"]
    #   )
    #
    #   plan.conditional? # => true
    #   plan.condition # => #<Cerbos::Output::PlanResources::Expression ...>
    def plan_resources(principal:, resource:, action: "", actions: [], aux_data: nil, include_metadata: false, request_id: SecureRandom.uuid, grpc_metadata: {})
      Error.handle do
        request = Protobuf::Cerbos::Request::V1::PlanResourcesRequest.new(
          principal: Input.coerce_required(principal, Input::Principal).to_protobuf,
          resource: Input.coerce_required(resource, Input::ResourceQuery).to_protobuf,
          action: action,
          actions: actions,
          aux_data: Input.coerce_optional(aux_data, Input::AuxData)&.to_protobuf,
          include_meta: include_metadata,
          request_id: request_id
        )

        response = @cerbos_service.call(:plan_resources, request, grpc_metadata)

        Output::PlanResources.from_protobuf(response).tap do |output|
          handle_validation_errors output
        end
      end
    end

    # Retrieve information about the Cerbos PDP server.
    #
    # @param grpc_metadata [Hash{String, Symbol => String, Array<String>}] gRPC metadata (a.k.a. HTTP headers) to add to the request.
    #
    # @return [Output::ServerInfo]
    def server_info(grpc_metadata: {})
      Error.handle do
        request = Protobuf::Cerbos::Request::V1::ServerInfoRequest.new

        response = @cerbos_service.call(:server_info, request, grpc_metadata)

        Output::ServerInfo.from_protobuf(response)
      end
    end

    private

    def handle_validation_errors(output)
      return if @on_validation_error == :return

      validation_errors = output.validation_errors
      return if validation_errors.empty?

      raise Error::ValidationFailed.new(validation_errors) if @on_validation_error == :raise

      @on_validation_error.call validation_errors
    end
  end
end
