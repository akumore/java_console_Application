# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'rspec/mocks'

# Load homegate export in order to get tests running TODO: move this into a better place
require 'export/export'

# use poltergeist/phantomjs for js testing
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

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
  config.extend ExhibitMacros

  config.before(:each) do
    Mongoid.database.collections.each do |collection|
      collection.remove unless collection.name =~ /^system\./
    end
    FileUtils.rmtree('tmp/test_uploads') if Dir.exist?('tmp/test_uploads')
  end
end

RSpec::Mocks.configuration do |config|
  config.add_stub_and_should_receive_to(SimpleDelegator)
end

# fixes .should_receive on objects using the delegator (SimpleDelegator)
# https://github.com/rspec/rspec-mocks/pull/116

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
