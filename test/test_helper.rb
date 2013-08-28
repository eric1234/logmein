require 'rails/test_help'
require "authlogic/test_case"
require 'capybara/rails'

class ActiveSupport::TestCase
  include Authlogic::TestCase
  setup :activate_authlogic

  # Ensure default config is restored before every test
  setup do
    Logmein.authenticated_model_name = 'User'
    Logmein.login_destination = :root_url
    Logmein.logout_destination = :root_url
  end

  protected

  # A fixture for creating a new user. This user is explicitly NOT logged in
  # despite AuthLogic's attempts to do so.
  def create_user
    User.create! do |u|
      u.email = 'joe@example.com'
      u.password = 'password'
      u.password_confirmation = 'password'
    end.tap do
      Session.find.destroy if Session.find
    end
  end
end

# Like with_routing except:
#
#   * Can be used across an entire TestCase
#   * Can work with a real browser (i.e. Capybara) in integration tests.
#   * Routes are appended to already defined routes
#
# Just assign a block to the class attribute "custom_routes". This block will
# execute as if it is being called from within the routes.rb draw block.
module TestRoutes
  extend ActiveSupport::Concern

  included do
    class_attribute :custom_routes
    setup :install_routes
    teardown :restore_routes
  end

  private

  def install_routes
    # Easier to refer to
    routes = Rails.application.routes

    # Clear out any already loaded routes
    routes.disable_clear_and_finalize = true
    routes.clear!

    # Load routes from application and engines
    Rails.application.routes_reloader.paths.each{ |path| load(path) }

    # Bring custom route block into closure and eval in context of draw
    custom = self.class.custom_routes
    routes.draw {instance_eval &custom}
  ensure
    # Wrap up route defination
    routes.disable_clear_and_finalize = false
    routes.finalize!
  end

  def restore_routes
    # Go back to just whatever the app and engines say
    Rails.application.reload_routes!
  end

end

class ActionController::TestCase
  include TestRoutes
end

DatabaseCleaner.strategy = :truncation
class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include TestRoutes
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  teardown do
    DatabaseCleaner.clean
  end
end

# A authenticated model for our tests to play with.
class User < ActiveRecord::Base; acts_as_authentic end
