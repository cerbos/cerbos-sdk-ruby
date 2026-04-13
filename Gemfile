# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "openssl"
gem "rake"

group :development do
  gem "dotenv"
  gem "irb"
end

group :docs do
  gem "commonmarker"
  gem "webrick"
  gem "yard"
end

group :lint do
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "standard"
end

group :protos do
  gem "parallel"
end

group :test do
  gem "jwt"
  gem "rspec"
  gem "rubyzip"

  dependency_name = ENV.fetch("TEST_MATRIX_DEPENDENCY_NAME", "")
  dependency_version = ENV.fetch("TEST_MATRIX_DEPENDENCY_VERSION", "")
  gem dependency_name, "~> #{dependency_version}.0" unless dependency_name.empty? || dependency_version.empty?
end
