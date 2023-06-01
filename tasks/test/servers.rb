# frozen_string_literal: true

require "json"
require "open3"
require "openssl"
require "rake/file_utils"

module Tasks
  module Test
    module Servers
      class << self
        include FileUtils

        def start
          generate_self_signed_certificate "server"
          generate_self_signed_certificate "client"
          mkdir_p File.expand_path("../../tmp/socket", __dir__)
          sh(*docker_compose_command("up", "--wait"))
        end

        def export_policies_version
          cerbos_version = Gem::Version.new(ENV.fetch("CERBOS_VERSION").delete_suffix("-prerelease"))

          ENV["POLICIES_VERSION"] = Dir.glob("*", base: "spec/servers/policies").max_by { |policies_directory|
            policies_version = Gem::Version.new(policies_directory)
            if policies_version <= cerbos_version
              policies_version
            else
              Gem::Version.new("0")
            end
          }
        end

        def export_ports
          command = docker_compose_command("ps", "--format", "json")
          output, status = Open3.capture2(*command)
          raise "`#{command.join(" ")}` exited with status #{status.exitstatus}" unless status.success?

          ports(JSON.parse(output)).each do |service, port|
            ENV["CERBOS_PORT_#{service.upcase}"] = port.to_s
          end
        end

        def stop
          ENV["POLICIES_VERSION"] = ""
          sh(*docker_compose_command("down"))
        end

        private

        def ports(containers)
          containers
            .map { |container| [container.fetch("Service"), port(container)] }
            .to_h
            .compact
        end

        def port(container)
          container
            .fetch("Publishers")
            .find { |publisher| publisher.fetch("TargetPort") == 3593 }
            &.fetch("PublishedPort")
        end

        def docker_compose_command(*args)
          [
            {"USER" => "#{Process.uid}:#{Process.gid}"},
            "docker", "compose",
            "--file", File.expand_path("../../spec/servers/docker-compose.yml", __dir__),
            *args
          ]
        end

        def generate_self_signed_certificate(name)
          root_key = OpenSSL::PKey::RSA.new(4096)

          root_cert = OpenSSL::X509::Certificate.new
          root_cert.version = 2
          root_cert.serial = 1
          root_cert.subject = OpenSSL::X509::Name.parse("/CN=#{name}")
          root_cert.issuer = root_cert.subject
          root_cert.public_key = root_key.public_key
          root_cert.not_before = Time.now
          root_cert.not_after = root_cert.not_before + 365 * 24 * 60 * 60

          root_extension_factory = OpenSSL::X509::ExtensionFactory.new
          root_extension_factory.subject_certificate = root_cert
          root_extension_factory.issuer_certificate = root_cert

          root_cert.add_extension root_extension_factory.create_extension("basicConstraints", "CA:TRUE", true)
          root_cert.add_extension root_extension_factory.create_extension("keyUsage", "keyCertSign, cRLSign", true)
          root_cert.add_extension root_extension_factory.create_extension("subjectKeyIdentifier", "hash", false)
          root_cert.add_extension root_extension_factory.create_extension("authorityKeyIdentifier", "keyid:always", false)

          root_cert.sign root_key, OpenSSL::Digest.new("SHA256")

          key = OpenSSL::PKey::RSA.new(4096)

          cert = OpenSSL::X509::Certificate.new
          cert.version = 2
          cert.serial = 2
          cert.subject = OpenSSL::X509::Name.parse("/CN=localhost")
          cert.issuer = root_cert.subject
          cert.public_key = key.public_key
          cert.not_before = root_cert.not_before
          cert.not_after = root_cert.not_after

          extension_factory = OpenSSL::X509::ExtensionFactory.new
          extension_factory.subject_certificate = cert
          extension_factory.issuer_certificate = root_cert

          cert.add_extension extension_factory.create_extension("keyUsage", "digitalSignature", true)
          cert.add_extension extension_factory.create_extension("subjectKeyIdentifier", "hash", false)
          cert.add_extension extension_factory.create_extension("subjectAltName", "DNS:localhost", false)

          cert.sign root_key, OpenSSL::Digest.new("SHA256")

          directory = File.expand_path("../../tmp/certificates", __dir__)
          mkdir_p directory
          File.write "#{directory}/#{name}.root.crt", root_cert.to_pem
          File.write "#{directory}/#{name}.crt", cert.to_pem
          File.write "#{directory}/#{name}.key", key.private_to_pem
        end
      end
    end
  end
end
