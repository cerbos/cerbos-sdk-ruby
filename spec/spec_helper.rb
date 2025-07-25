# frozen_string_literal: true

require "dotenv/load"

require "cerbos"
require "concurrent/promises"
require "jwt"
require "uri"
require "zip"

RSpec.configure do |config|
  config.default_formatter = "doc" if config.files_to_run.one?
  config.disable_monkey_patching!
  config.filter_run_excluding :hub unless ENV["CERBOS_HUB_API_ENDPOINT"]
  config.filter_run_when_matching :focus
  config.order = :random
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  Kernel.srand config.seed
end

RSpec::Matchers.define_negated_matcher :not_yield, :yield_control
