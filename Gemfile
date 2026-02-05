# frozen_string_literal: true

require "json"

source "https://rubygems.org"

gemspec

gem "dotenv"
gem "jwt"
gem "openssl"
gem "pry"
gem "rake"
gem "reline"
gem "rspec"
gem "rubocop-rake"
gem "rubocop-rspec"
gem "rubyzip"
gem "standard"

group :docs do
  gem "commonmarker", "< 1.0" # https://github.com/lsegal/yard/issues/1528
  gem "webrick"
  gem "yard"
end

dependency_name = ENV.fetch("TEST_MATRIX_DEPENDENCY_NAME", "")
dependency_version = ENV.fetch("TEST_MATRIX_DEPENDENCY_VERSION", "")
gem dependency_name, "~> #{dependency_version}.0" unless dependency_name.empty? || dependency_version.empty?
