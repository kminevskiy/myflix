Myflix::Application.configure do
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.eager_load = false

  config.action_mailer.default_url_options = { host: "localhost:3000" }
  config.action_mailer.delivery_method = :test
=begin
  config.action_mailer.smtp_settings = {
  address:              'smtp.fastmail.com',
  port:                 587,
  domain:               'myflix.local',
  user_name:            ENV["fm_user"],
  password:             ENV["fm_password"],
  authentication:       'plain',
  enable_starttls_auto: true  }
=end
end
