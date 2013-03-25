# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Load homegate export in order to get tests running TODO: move this into a better place
require 'export/export'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.javascript_driver = :webkit

Fabrication.configure do |config|
  fabricator_dir = "spec/fabricators"
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
  config.extend DefaultUrlOptionsHelper
  config.extend RequestMacros
  config.include ActionView::Helpers::NumberHelper
  config.include MockGeocoder
  config.include Delorean
  config.include ExporterFileSystemHelpers

  config.after(:each) do
    Mongoid.database.collections.each do |collection|
      collection.remove unless collection.name =~ /^system\./
    end
  end
end


# prepare monkey patch to set default locale for ALL spec but not within the Cms
class ActionView::TestCase::TestController
  def default_url_options_with_locale(options={})
    default_url_options_without_locale.merge(:locale => I18n.default_locale)
  end
end

class ActionDispatch::Routing::RouteSet
  def default_url_options_with_locale(options={})
    default_url_options_without_locale.merge(:locale => I18n.default_locale)
  end
end
