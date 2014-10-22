require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Qomo
  class Application < Rails::Application
    GIT_VERSION = `git rev-parse --short HEAD`

    config.time_zone = 'Beijing'
    config.autoload_paths << Rails.root.join('lib')

  end
end
