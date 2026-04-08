# frozen_string_literal: true

require "rake/clean"

desc "Update protos"
task :protos do
  require_relative "tasks/protos"

  Tasks::Protos.call
end

desc "Generate client code"
task :generate do
  require_relative "tasks/generate"

  Tasks::Generate.call
end

begin
  require "rubocop/rake_task"

  RuboCop::RakeTask.new :lint do |task|
    task.formatters = ["clang", "github"] if ENV["CI"]
  end
rescue LoadError
  # Bundle installed without lint group
end

begin
  require "rspec/core/rake_task"
  require_relative "tasks/test/servers"

  CLEAN.include "tmp"

  ENV["CERBOS_VERSION"] ||= "0.16.0"
  ENV["CERBOS_IMAGE_TAG"] ||= ENV["CERBOS_VERSION"].end_with?("-prerelease") ? "dev" : ENV["CERBOS_VERSION"]

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
rescue LoadError
  # Bundle installed without test group
end

begin
  require "yard"

  CLEAN.include ".yardoc"
  CLOBBER.include "doc"

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

namespace :release do
  CLOBBER.include "pkg"

  built_gem_path = nil
  attestation_path = nil

  desc "Build gem"
  task :build do
    require "bundler/gem_helper"
    built_gem_path = Bundler::GemHelper.new.build_gem
  end

  desc "Sign gem"
  task sign: [:build] do
    attestation_path = "#{built_gem_path}.sigstore.json"
    sh "cosign", "sign-blob", built_gem_path, "--bundle", attestation_path

    # https://github.com/rubygems/rubygems.org/issues/6369
    require "json"
    bundle = JSON.load_file(attestation_path)
    bundle.fetch("verificationMaterial").delete "timestampVerificationData"
    File.write attestation_path, JSON.generate(bundle)
  end

  desc "Push gem"
  task push: [:sign] do
    sh "gem", "push", built_gem_path, "--attestation", attestation_path
  end

  desc "Extract release notes from changelog"
  task :notes do
    require "cerbos/version"

    version = Cerbos::VERSION

    mkdir_p "pkg", verbose: false

    lines = File.open "CHANGELOG.md", "r" do |changelog|
      changelog
        .each_line
        .lazy
        .drop_while { |line| !line.start_with?("## [#{version}] ") }
        .drop(1)
        .drop_while { |line| line == "\n" }
        .take_while { |line| !line.start_with?("## ") }
        .to_a
    end

    lines.pop while lines.last == "\n"

    File.open "pkg/release.md", "w" do |release_notes|
      lines.each do |line|
        release_notes << line
      end
    end

    File.write "pkg/version.txt", version
  end

  desc "Tag release"
  task :tag do
    require "cerbos/version"

    version = Cerbos::VERSION
    tag = "v#{version}"

    abort "Unclean working directory" unless system("git", "diff", "--quiet")

    sh "git", "fetch", "--quiet", "upstream", "main"
    abort "Not on latest main" if `git rev-parse HEAD` != `git rev-parse FETCH_HEAD`

    sh "git", "tag", "--message=Version #{version}", "--sign", tag
    sh "git", "push", "upstream", tag
  end
end

task default: [:docs, :lint, :test]
