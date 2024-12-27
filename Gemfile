# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.4.0"

gem "rails", "8.0.1"

gem "aasm"
gem "acts_as_list"
gem "auto_strip_attributes"
gem "barby"
gem "bcrypt"
gem "bootsnap", require: false
gem "commonmarker"
gem "csv"
gem "dalli"
gem "devise"
gem "dmtx"
gem "drb"
gem "ed25519"
gem "fast_blank"
gem "fhir_models", "~> 4.3"
gem "health_cards", github: "jlduran/health_cards", branch: "development"
gem "importmap-rails"
gem "jbuilder"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "kamal", require: false
gem "kaminari"
gem "mutex_m"
gem "nokogiri"
gem "pdf-core", github: "Labtec/pdf-core", branch: "pdfa-1b"
gem "pg"
gem "pg_search"
gem "phonelib"
gem "prawn"
gem "prawn-svg"
gem "prawn-table"
gem "propshaft"
gem "puma", ">= 6.0"
gem "rails-html-sanitizer"
gem "rails-i18n"
gem "sassc-rails" # TODO
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "sprockets-rails"
gem "stimulus-rails"
gem "thruster", require: false
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "webauthn"

group :development, :test do
  gem "brakeman", require: false
  gem "capistrano3-puma"
  gem "capistrano-bundler"
  gem "capistrano-rails"
  gem "capistrano-rbenv"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "bcrypt_pbkdf"
  gem "flamegraph", require: false
  gem "i18n-tasks", require: false
  gem "rack-mini-profiler", require: false
  gem "stackprof"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
