# frozen_string_literal: true

require_relative "lib/cerbos/version"

Gem::Specification.new do |spec|
  spec.name = "cerbos"
  spec.version = Cerbos::VERSION
  spec.summary = "Client library for authorization via Cerbos"
  spec.description = "Perform authorization in Ruby applications by interacting with the Cerbos policy decision point."
  spec.authors = ["Cerbos"]
  spec.email = ["help@cerbos.dev"]
  spec.license = "Apache-2.0"

  spec.homepage = "https://github.com/cerbos/cerbos-sdk-ruby"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://cerbos.github.io/cerbos-sdk-ruby"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.metadata["rubygems_mfa_required"] = "true"

  spec.require_paths = ["lib"]
  spec.files = Dir[
    "lib/**/*.rb",
    ".yardopts",
    "cerbos.gemspec",
    "CHANGELOG.md",
    "LICENSE.txt",
    "README.md",
    "yard_extensions.rb"
  ]

  spec.required_ruby_version = ">= 3.2.0"
  spec.add_dependency "concurrent-ruby", "~> 1.2"
  spec.add_dependency "grpc", "~> 1.52"
  spec.add_dependency "google-protobuf", ">= 3.21.12", "< 5.0"
end
