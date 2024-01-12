# frozen_string_literal: true

class StubServer
  attr_reader :port, :service

  def initialize
    @service = Cerbos::Protobuf::Cerbos::Svc::V1::CerbosService::Service.new
  end

  def start
    @server = GRPC::RpcServer.new(pool_size: 1)
    @port = @server.add_http2_port("localhost:0", :this_port_is_insecure)
    @server.handle @service
    @thread = Thread.new { @server.run }
    @server.wait_till_running
  end

  def stop
    @server.stop
    @thread.join
  end
end
