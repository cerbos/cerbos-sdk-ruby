# frozen_string_literal: true

require_relative "stub_server"

RSpec.describe Cerbos::Client do
  subject(:client) { described_class.new(target, grpc_metadata: grpc_metadata, on_validation_error: on_validation_error, tls: tls) }

  let(:target) { "#{host}:#{port}" }
  let(:host) { "localhost" }
  let(:grpc_metadata) { {} }
  let(:on_validation_error) { :return }
  let(:cerbos_version) { ENV.fetch("CERBOS_VERSION") }

  shared_examples "client" do
    describe "#allow?" do
      subject(:response) do
        client.allow?(
          principal: {
            id: "me@example.com",
            policy_version: "1",
            scope: "test",
            roles: ["USER"],
            attr: {
              country: {
                alpha2: "",
                alpha3: "NZL"
              }
            }
          },
          resource: {
            kind: "document",
            id: "mine",
            policy_version: "1",
            scope: "test",
            attr: {
              owner: "me@example.com"
            }
          },
          action: "edit",
          aux_data: {
            jwt: {
              token: JWT.encode({delete: true}, nil, "none")
            }
          },
          request_id: "42"
        )
      end

      it "checks if a principal is allowed to perform an action on a resource" do
        expect(response).to be(true)
      end
    end

    describe "#check_health" do
      subject(:response) do
        client.check_health(service: service)
      end

      context "when checking the Cerbos service" do
        let(:service) { "cerbos.svc.v1.CerbosService" }

        it "checks the Cerbos service health" do
          expect(response).to eq(Cerbos::Output::HealthCheck.new(status: :SERVING))
        end
      end

      context "when checking the admin service" do
        let(:service) { "cerbos.svc.v1.CerbosAdminService" }

        it "checks the admin service health" do
          expect(response).to eq(Cerbos::Output::HealthCheck.new(status: :DISABLED))
        end
      end
    end

    describe "#check_resource" do
      subject(:response) do
        client.check_resource(
          principal: {
            id: "me@example.com",
            policy_version: "1",
            scope: "test",
            roles: ["USER"],
            attr: {
              country: {
                alpha2: "",
                alpha3: "NZL"
              }
            }
          },
          resource: {
            kind: "document",
            id: "mine",
            policy_version: "1",
            scope: "test",
            attr: {
              owner: "me@example.com"
            }
          },
          actions: ["view", "edit", "delete"],
          aux_data: {
            jwt: {
              token: JWT.encode({delete: true}, nil, "none")
            }
          },
          include_metadata: true,
          request_id: "42"
        )
      end

      it "checks a principal's permissions on a resource" do
        expect(response).to eq(Cerbos::Output::CheckResources::Result.new(
          resource: Cerbos::Output::CheckResources::Result::Resource.new(
            kind: "document",
            id: "mine",
            policy_version: "1",
            scope: "test"
          ),
          actions: {
            "view" => :EFFECT_ALLOW,
            "edit" => :EFFECT_ALLOW,
            "delete" => :EFFECT_ALLOW
          },
          validation_errors: [
            Cerbos::Output::ValidationError.new(
              path: "/country/alpha2",
              message: "does not match pattern '[A-Z]{2}'",
              source: :SOURCE_PRINCIPAL
            )
          ],
          metadata: Cerbos::Output::CheckResources::Result::Metadata.new(
            actions: {
              "view" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                matched_policy: "resource.document.v1/test",
                matched_scope: "test"
              ),
              "edit" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                matched_policy: "resource.document.v1/test",
                matched_scope: "test"
              ),
              "delete" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                matched_policy: "resource.document.v1/test",
                matched_scope: ""
              )
            },
            effective_derived_roles: ["OWNER"]
          ),
          outputs:
            if cerbos_version_at_least?("0.27.0")
              [
                Cerbos::Output::CheckResources::Result::Output.new(
                  source: "resource.document.v1#delete",
                  value: "delete_allowed:me@example.com"
                )
              ]
            else
              []
            end
        ))
      end
    end

    describe "#check_resources" do
      subject(:response) do
        client.check_resources(
          principal: {
            id: "me@example.com",
            policy_version: "1",
            scope: "test",
            roles: ["USER"],
            attr: {
              country: {
                alpha2: "",
                alpha3: "NZL"
              }
            }
          },
          resources: [
            {
              resource: {
                kind: "document",
                id: "mine",
                policy_version: "1",
                scope: "test",
                attr: {
                  owner: "me@example.com"
                }
              },
              actions: ["view", "edit", "delete"]
            },
            {
              resource: {
                kind: "document",
                id: "theirs",
                policy_version: "1",
                scope: "test",
                attr: {
                  owner: "them@example.com"
                }
              },
              actions: ["view", "edit", "delete"]
            },
            {
              resource: {
                kind: "document",
                id: "invalid",
                policy_version: "1",
                scope: "test",
                attr: {
                  owner: 123
                }
              },
              actions: ["view", "edit", "delete"]
            }
          ],
          aux_data: {
            jwt: {
              token: JWT.encode({delete: true}, nil, "none")
            }
          },
          include_metadata: true,
          request_id: "42"
        )
      end

      it "checks a principal's permissions on a set of resources" do
        expect(response).to eq(Cerbos::Output::CheckResources.new(
          request_id: "42",
          results: [
            Cerbos::Output::CheckResources::Result.new(
              resource: Cerbos::Output::CheckResources::Result::Resource.new(
                kind: "document",
                id: "mine",
                policy_version: "1",
                scope: "test"
              ),
              actions: {
                "view" => :EFFECT_ALLOW,
                "edit" => :EFFECT_ALLOW,
                "delete" => :EFFECT_ALLOW
              },
              validation_errors: [
                Cerbos::Output::ValidationError.new(
                  path: "/country/alpha2",
                  message: "does not match pattern '[A-Z]{2}'",
                  source: :SOURCE_PRINCIPAL
                )
              ],
              metadata: Cerbos::Output::CheckResources::Result::Metadata.new(
                actions: {
                  "view" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                    matched_policy: "resource.document.v1/test",
                    matched_scope: "test"
                  ),
                  "edit" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                    matched_policy: "resource.document.v1/test",
                    matched_scope: "test"
                  ),
                  "delete" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                    matched_policy: "resource.document.v1/test",
                    matched_scope: ""
                  )
                },
                effective_derived_roles: ["OWNER"]
              ),
              outputs:
                if cerbos_version_at_least?("0.27.0")
                  [
                    Cerbos::Output::CheckResources::Result::Output.new(
                      source: "resource.document.v1#delete",
                      value: "delete_allowed:me@example.com"
                    )
                  ]
                else
                  []
                end
            ),
            Cerbos::Output::CheckResources::Result.new(
              resource: Cerbos::Output::CheckResources::Result::Resource.new(
                kind: "document",
                id: "theirs",
                policy_version: "1",
                scope: "test"
              ),
              actions: {
                "view" => :EFFECT_ALLOW,
                "edit" => :EFFECT_DENY,
                "delete" => :EFFECT_ALLOW
              },
              validation_errors: [
                Cerbos::Output::ValidationError.new(
                  path: "/country/alpha2",
                  message: "does not match pattern '[A-Z]{2}'",
                  source: :SOURCE_PRINCIPAL
                )
              ],
              metadata: Cerbos::Output::CheckResources::Result::Metadata.new(
                actions: {
                  "view" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                    matched_policy: "resource.document.v1/test",
                    matched_scope: "test"
                  ),
                  "edit" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                    matched_policy: "resource.document.v1/test",
                    matched_scope: ""
                  ),
                  "delete" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                    matched_policy: "resource.document.v1/test",
                    matched_scope: ""
                  )
                },
                effective_derived_roles: []
              ),
              outputs:
                if cerbos_version_at_least?("0.27.0")
                  [
                    Cerbos::Output::CheckResources::Result::Output.new(
                      source: "resource.document.v1#delete",
                      value: "delete_allowed:me@example.com"
                    )
                  ]
                else
                  []
                end
            ),
            Cerbos::Output::CheckResources::Result.new(
              resource: Cerbos::Output::CheckResources::Result::Resource.new(
                kind: "document",
                id: "invalid",
                policy_version: "1",
                scope: "test"
              ),
              actions: {
                "view" => :EFFECT_ALLOW,
                "edit" => :EFFECT_DENY,
                "delete" => :EFFECT_ALLOW
              },
              validation_errors: [
                Cerbos::Output::ValidationError.new(
                  path: "/country/alpha2",
                  message: "does not match pattern '[A-Z]{2}'",
                  source: :SOURCE_PRINCIPAL
                ),
                Cerbos::Output::ValidationError.new(
                  path: "/owner",
                  message: "expected string, but got number",
                  source: :SOURCE_RESOURCE
                )
              ],
              metadata: Cerbos::Output::CheckResources::Result::Metadata.new(
                actions: {
                  "view" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                    matched_policy: "resource.document.v1/test",
                    matched_scope: "test"
                  ),
                  "edit" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                    matched_policy: "resource.document.v1/test",
                    matched_scope: ""
                  ),
                  "delete" => Cerbos::Output::CheckResources::Result::Metadata::Effect.new(
                    matched_policy: "resource.document.v1/test",
                    matched_scope: ""
                  )
                },
                effective_derived_roles: []
              ),
              outputs:
                if cerbos_version_at_least?("0.27.0")
                  [
                    Cerbos::Output::CheckResources::Result::Output.new(
                      source: "resource.document.v1#delete",
                      value: "delete_allowed:me@example.com"
                    )
                  ]
                else
                  []
                end
            )
          ]
        ))
      end
    end

    describe "#plan_resources" do
      context "with action" do
        subject(:response) do
          client.plan_resources(
            principal: {
              id: "me@example.com",
              policy_version: "1",
              scope: "test",
              roles: ["USER"],
              attr: {
                country: {
                  alpha2: "",
                  alpha3: "NZL"
                }
              }
            },
            resource: {
              kind: "document",
              policy_version: "1",
              scope: "test",
              attr: {}
            },
            action: "edit",
            aux_data: {
              jwt: {
                token: JWT.encode({delete: true}, nil, "none")
              }
            },
            include_metadata: true,
            request_id: "42"
          )
        end

        it "returns a query plan for resources" do
          expect(response).to eq(Cerbos::Output::PlanResources.new(
            request_id: "42",
            kind: :KIND_CONDITIONAL,
            condition: Cerbos::Output::PlanResources::Expression.new(
              operator: "eq",
              operands: [
                Cerbos::Output::PlanResources::Expression::Variable.new(name: "request.resource.attr.owner"),
                Cerbos::Output::PlanResources::Expression::Value.new(value: "me@example.com")
              ]
            ),
            validation_errors:
              if cerbos_version_at_least?("0.19.0")
                [
                  Cerbos::Output::ValidationError.new(
                    path: "/country/alpha2",
                    message: "does not match pattern '[A-Z]{2}'",
                    source: :SOURCE_PRINCIPAL
                  )
                ]
              else
                []
              end,
            metadata: Cerbos::Output::PlanResources::Metadata.new(
              condition_string:
                if cerbos_version_at_least?("0.18.0")
                  '(eq request.resource.attr.owner "me@example.com")'
                else
                  '(request.resource.attr.owner == "me@example.com")'
                end,
              matched_scope: "test",
              matched_scopes: {}
            )
          ))
        end
      end

      context "with actions" do
        subject(:response) do
          client.plan_resources(
            principal: {
              id: "me@example.com",
              policy_version: "1",
              scope: "test",
              roles: ["USER"],
              attr: {
                country: {
                  alpha2: "",
                  alpha3: "NZL"
                }
              }
            },
            resource: {
              kind: "document",
              policy_version: "1",
              scope: "test",
              attr: {}
            },
            actions: ["edit"],
            aux_data: {
              jwt: {
                token: JWT.encode({delete: true}, nil, "none")
              }
            },
            include_metadata: true,
            request_id: "42"
          )
        end

        before do
          skip "Not supported before Cerbos 0.44.0" unless cerbos_version_at_least?("0.44.0")
        end

        it "returns a query plan for resources" do
          expect(response).to eq(Cerbos::Output::PlanResources.new(
            request_id: "42",
            kind: :KIND_CONDITIONAL,
            condition: Cerbos::Output::PlanResources::Expression.new(
              operator: "eq",
              operands: [
                Cerbos::Output::PlanResources::Expression::Variable.new(name: "request.resource.attr.owner"),
                Cerbos::Output::PlanResources::Expression::Value.new(value: "me@example.com")
              ]
            ),
            validation_errors: [
              Cerbos::Output::ValidationError.new(
                path: "/country/alpha2",
                message: "does not match pattern '[A-Z]{2}'",
                source: :SOURCE_PRINCIPAL
              )
            ],
            metadata: Cerbos::Output::PlanResources::Metadata.new(
              condition_string: '(eq request.resource.attr.owner "me@example.com")',
              matched_scope: "",
              matched_scopes: {"edit" => "test"}
            )
          ))
        end
      end
    end

    describe "#server_info" do
      subject(:response) { client.server_info }

      it "returns information about the server" do
        expect(response).to be_a(Cerbos::Output::ServerInfo).and(have_attributes(
          built_at: an_instance_of(Time),
          commit: a_string_matching(/\A[0-9a-f]{40}\z/),
          version: cerbos_version
        ))
      end
    end

    context "when configured to raise on validation error" do
      let(:on_validation_error) { :raise }

      it "raises an error when validation fails in #check_resources", :aggregate_failures do
        expect {
          client.allow?(
            principal: {
              id: "me@example.com",
              policy_version: "1",
              scope: "test",
              roles: ["USER"],
              attr: {
                country: {
                  alpha2: "",
                  alpha3: "NZL"
                }
              }
            },
            resource: {
              kind: "document",
              id: "invalid",
              policy_version: "1",
              scope: "test",
              attr: {
                owner: 123
              }
            },
            action: "view"
          )
        }.to raise_error { |error|
          expect(error).to be_a(Cerbos::Error::ValidationFailed).and(have_attributes(
            validation_errors: [
              Cerbos::Output::ValidationError.new(
                path: "/country/alpha2",
                message: "does not match pattern '[A-Z]{2}'",
                source: :SOURCE_PRINCIPAL
              ),
              Cerbos::Output::ValidationError.new(
                path: "/owner",
                message: "expected string, but got number",
                source: :SOURCE_RESOURCE
              )
            ]
          ))
        }
      end

      it "raises an error when validation fails in #plan_resources", :aggregate_failures do
        skip "Not supported before Cerbos 0.19.0" unless cerbos_version_at_least?("0.19.0")

        expect {
          client.plan_resources(
            principal: {
              id: "me@example.com",
              policy_version: "1",
              scope: "test",
              roles: ["USER"],
              attr: {
                country: {
                  alpha2: "",
                  alpha3: "NZL"
                }
              }
            },
            resource: {
              kind: "document",
              policy_version: "1",
              scope: "test",
              attr: {}
            },
            action: "edit"
          )
        }.to raise_error { |error|
          expect(error).to be_a(Cerbos::Error::ValidationFailed).and(have_attributes(
            validation_errors: [
              Cerbos::Output::ValidationError.new(
                path: "/country/alpha2",
                message: "does not match pattern '[A-Z]{2}'",
                source: :SOURCE_PRINCIPAL
              )
            ]
          ))
        }
      end
    end

    context "when configured with a callback on validation error" do
      let(:on_validation_error) { instance_double(Proc, call: nil) }

      it "invokes the callback when validation fails in #check_resources", :aggregate_failures do
        client.allow?(
          principal: {
            id: "me@example.com",
            policy_version: "1",
            scope: "test",
            roles: ["USER"],
            attr: {
              country: {
                alpha2: "",
                alpha3: "NZL"
              }
            }
          },
          resource: {
            kind: "document",
            id: "invalid",
            policy_version: "1",
            scope: "test",
            attr: {
              owner: 123
            }
          },
          action: "view"
        )

        expect(on_validation_error).to have_received(:call).with([
          Cerbos::Output::ValidationError.new(
            path: "/country/alpha2",
            message: "does not match pattern '[A-Z]{2}'",
            source: :SOURCE_PRINCIPAL
          ),
          Cerbos::Output::ValidationError.new(
            path: "/owner",
            message: "expected string, but got number",
            source: :SOURCE_RESOURCE
          )
        ])
      end

      it "invokes the callback when validation fails in #plan_resources", :aggregate_failures do
        skip "Not supported before Cerbos 0.19.0" unless cerbos_version_at_least?("0.19.0")

        client.plan_resources(
          principal: {
            id: "me@example.com",
            policy_version: "1",
            scope: "test",
            roles: ["USER"],
            attr: {
              country: {
                alpha2: "",
                alpha3: "NZL"
              }
            }
          },
          resource: {
            kind: "document",
            policy_version: "1",
            scope: "test",
            attr: {}
          },
          action: "edit"
        )

        expect(on_validation_error).to have_received(:call).with([
          Cerbos::Output::ValidationError.new(
            path: "/country/alpha2",
            message: "does not match pattern '[A-Z]{2}'",
            source: :SOURCE_PRINCIPAL
          )
        ])
      end
    end
  end

  context "with plaintext" do
    let(:port) { ENV.fetch("CERBOS_PORT_PLAINTEXT") }
    let(:tls) { false }

    include_examples "client"
  end

  context "with a Unix socket" do
    let(:target) { "unix:#{File.expand_path("../../tmp/socket/cerbos", __dir__)}" }
    let(:tls) { false }

    before do
      skip "Docker Desktop does not support bind-mounting Unix sockets" unless Gem::Platform.local.os == "linux"
    end

    include_examples "client"
  end

  context "with TLS" do
    let(:port) { ENV.fetch("CERBOS_PORT_TLS") }
    let(:tls) { Cerbos::TLS.new(root_certificates_pem: read_pem("server.root.crt")) }

    include_examples "client"
  end

  context "with mTLS" do
    let(:port) { ENV.fetch("CERBOS_PORT_MTLS") }
    let(:tls) { Cerbos::MutualTLS.new(root_certificates_pem: read_pem("server.root.crt"), client_certificate_pem: read_pem("client.crt"), client_key_pem: read_pem("client.key")) }

    include_examples "client"
  end

  context "when unavailable" do
    let(:target) { "cerbos.example.com:443" }
    let(:tls) { Cerbos::TLS.new }

    it "fails to perform RPC operations" do
      expect { client.server_info }.to raise_error(Cerbos::Error::Unavailable)
    end
  end

  describe "gRPC metadata" do
    let(:server) { StubServer.new }
    let(:service) { server.service }
    let(:port) { server.port }
    let(:tls) { false }
    let(:grpc_metadata) { {foo: "42"} }
    let(:response) { Cerbos::Protobuf::Cerbos::Response::V1::ServerInfoResponse.new }

    before do
      allow(service).to receive(:server_info).and_return(response)
      server.start
    end

    after do
      server.stop
    end

    [
      ["sets client-wide metadata on all requests", {}, {"foo" => "42"}],
      ["adds per-request metadata", {bar: ["99", "100"]}, {"foo" => "42", "bar" => ["99", "100"]}],
      ["overrides client-wide metadata with per-request metadata using symbol keys", {foo: "43", bar: ["99", "100"]}, {"foo" => "43", "bar" => ["99", "100"]}],
      ["overrides client-wide metadata with per-request metadata using string keys", {"foo" => "43", "bar" => ["99", "100"]}, {"foo" => "43", "bar" => ["99", "100"]}]
    ].each do |description, request_metadata, expected_metadata|
      it description do
        client.server_info grpc_metadata: request_metadata

        expect(service).to have_received(:server_info) do |_, call|
          expect(call.metadata).to match(expected_metadata.merge({"user-agent" => a_string_starting_with("cerbos-sdk-ruby/#{Cerbos::VERSION} grpc-ruby/#{GRPC::VERSION} ")}))
        end
      end
    end
  end

  def cerbos_version_at_least?(version)
    Gem::Version.new(cerbos_version.delete_suffix("-prerelease")) >= Gem::Version.new(version)
  end

  def read_pem(name)
    File.read(File.expand_path("../../tmp/certificates/#{name}", __dir__))
  end
end
