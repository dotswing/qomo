require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Qomo
  class Application < Rails::Application
    revision_file = File.join(Rails.root, 'REVISION')
    if File.exist? revision_file
      GIT_VERSION = File.read revision_file
    else
      GIT_VERSION = `git rev-parse --short HEAD`
    end


    config.time_zone = 'Beijing'
    config.autoload_paths << Rails.root.join('lib')

  end
end
