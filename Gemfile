# frozen_string_literal: true

require "json"

source "https://rubygems.org"

gemspec

gem "commonmarker", "< 1.0"
gem "jwt"
gem "openssl"
gem "pry"
gem "rake"
gem "rspec"
gem "rubocop-rake"
gem "rubocop-rspec"
gem "standard"
gem "webrick"
gem "yard"

dependency_name = ENV.fetch("TEST_MATRIX_DEPENDENCY_NAME", "")
dependency_version = ENV.fetch("TEST_MATRIX_DEPENDENCY_VERSION", "")
gem dependency_name, "~> #{dependency_version}.0" unless dependency_name.empty? || dependency_version.empty?
