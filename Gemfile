source 'https://rubygems.org'
ruby '2.3.3'

gem "bundler"
gem 'bootstrap-sass', '3.1.1.1'
gem 'coffee-rails'
gem 'rails', '5.0.1'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem "slim-rails"
gem "bcrypt"
gem "figaro"
gem "sidekiq"
gem "sentry-raven"

group :development do
  gem 'puma'
  gem "binding_of_caller"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
  gem "rails-controller-testing"
  gem "shoulda-matchers"
  gem "fabrication"
  gem "faker"
  gem "launchy"
end

group :test do
  gem 'database_cleaner'
  gem "capybara"
  gem "capybara-email"
  gem 'vcr'
end

group :production do
  gem 'rails_12factor'
end

