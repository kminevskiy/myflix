require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :slim
    end
    config.autoload_paths << "#{Rails.root}/lib"

    Raven.configure do |config|
      config.dsn = 'https://4367da693b6245f9a7d45bb488e7135a:d39ac2fcb9d34489babd0eb9eb6f1da5@sentry.io/146309'
    end
  end
end

