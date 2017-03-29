source 'https://rubygems.org'
ruby '2.3.3'

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
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-aws'
gem 'mini_magick'
gem 'stripe'
gem 'stripe_event'
gem 'draper', '3.0.0.pre1'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

group :development do
  gem 'puma'
  gem "binding_of_caller"
end

group :development, :test do
  gem 'pry'
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
  gem 'webmock'
  gem 'rails-perftest'
  gem 'ruby-prof'
end

group :production do
  gem 'rails_12factor'
end

