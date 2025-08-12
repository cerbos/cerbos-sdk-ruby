# frozen_string_literal: true

class StubServer
  attr_reader :port, :cerbos_service, :api_key_service, :store_service

  def initialize
    @cerbos_service = Cerbos::Protobuf::Cerbos::Svc::V1::CerbosService::Service.new
    @api_key_service = Cerbos::Protobuf::Cerbos::Cloud::Apikey::V1::ApiKeyService::Service.new
    @store_service = Cerbos::Protobuf::Cerbos::Cloud::Store::V1::CerbosStoreService::Service.new
  end

  def start
    @server = GRPC::RpcServer.new(pool_size: 1)
    @port = @server.add_http2_port("localhost:0", :this_port_is_insecure)
    @server.handle @cerbos_service
    @server.handle @api_key_service
    @server.handle @store_service
    @thread = Thread.new { @server.run }
    @server.wait_till_running
  end

  def stop
    @server.stop
    @thread.join
  end
end
