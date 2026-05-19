# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.10"

gem "bootsnap", require: false
gem "brakeman"
gem "bundler-audit"
gem "image_processing", "~> 1.14"
gem "importmap-rails"
gem "jbuilder"
gem "pg", "~> 1.6"
gem "puma", ">= 6.4.3"
gem "rails", "~> 8.1"
gem "redis", "~> 5.4"
gem "rexml", ">= 3.3.9"
gem "rubocop-rails"
gem "sidekiq", "8.1.5"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem 'webrick'

# Monitoring
gem 'yabeda-prometheus'
gem 'yabeda-puma-plugin'
gem 'yabeda-rails'
gem 'yabeda-sidekiq'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", "1.11.1", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "rubocop-rspec"
  gem "rubocop-capybara", ">= 2.21.0"  # Required for RuboCop 1.84+ compatibility
end

group :development do
  gem "rack-mini-profiler"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
