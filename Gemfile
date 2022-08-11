source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 6.0.5"
# Use mysql as the database for Active Record
gem "mysql2", ">= 0.4.4"
# Use Puma as the app server
gem "puma", "~> 4.1"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"

gem "rails-i18n"

gem "bootstrap-sass", "3.4.1"

gem "cancancan"

gem "config"

gem "bcrypt", "3.1.13"

gem "pagy"

gem "active_storage_validations", "0.8.2"

gem "image_processing", "1.9.3"

gem "mini_magick", "4.9.5"

gem "faker", "2.1.2"

gem "figaro"

gem "cocoon"

gem "devise"

gem "csv"

gem "activerecord-import"

gem "sidekiq"

gem "whenever"
# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"
# Use Active Model has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Use Active Storage variant
# gem "image_processing", "~> 1.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "database_cleaner", "~> 1.5"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
  gem "shoulda-matchers", "~> 5.0"
  gem "simplecov"
  gem "simplecov-rcov"
end

group :development do
  gem "bullet"
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
  gem "xmpp4r"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
