# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

require_relative "tasks/generate"
require_relative "tasks/test/servers"

ENV["CERBOS_VERSION"] ||= "0.16.0"
ENV["CERBOS_IMAGE_TAG"] ||= ENV["CERBOS_VERSION"].end_with?("-prerelease") ? "dev" : ENV["CERBOS_VERSION"]

desc "Generate client code"
task :generate do
  Tasks::Generate.call
end

RuboCop::RakeTask.new :lint do |task|
  task.formatters = ["clang", "github"] if ENV["CI"]
end

namespace :test do
  namespace :servers do
    desc "Start the test servers"
    task start: [:export_policies_version] do
      Tasks::Test::Servers.start
    end

    desc "Set POLICIES_VERSION to the maximum supported with CERBOS_VERSION"
    task :export_policies_version do
      Tasks::Test::Servers.export_policies_version
    end

    desc "Set CERBOS_PORTS to the test server containers' published GRPC ports"
    task :export_ports do
      Tasks::Test::Servers.export_ports
    end

    desc "Stop the test servers"
    task :stop do
      Tasks::Test::Servers.stop
    end
  end

  RSpec::Core::RakeTask.new :hub do |task|
    task.rspec_opts = "--tag hub"
  end
end

RSpec::Core::RakeTask.new test: ["test:servers:export_policies_version", "test:servers:export_ports"]

begin
  require "yard"

  desc "Generate documentation"
  YARD::Rake::YardocTask.new :docs do |task|
    task.options = ["--fail-on-warning", "--no-stats"]

    task.after = lambda do
      touch "doc/.nojekyll", verbose: false

      stats = YARD::CLI::Stats.new(false)
      stats.run "--compact", "--list-undoc"
      undocumented = stats.instance_variable_get(:@undocumented)
      abort "\nFound #{undocumented} undocumented objects" unless undocumented.zero?
    end
  end
rescue LoadError
  # Bundle installed without docs group
end

namespace :docs do
  desc "Check for broken links"
  task :check_links do
    sh "bin/check-links"
  end

  desc "Run documentation server"
  task :server do
    exec "bin/yard", "server", "--reload"
  end
end

task default: [:docs, :lint, :test]
