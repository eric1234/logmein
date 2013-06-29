# We ideally want the application not need to declare the dependency
# on authlogic. It is just implied since logmein only works with
# authlogic. But authlogic assumes ActiveRecord. There are ways to make
# authlogic work without ActiveRecord so we only want to do this
# require if the app is using ActiveRecord
require 'authlogic' if defined? ActiveRecord

# We are trying to avoid accessive configuration but if a bit of config
# will go a long way towards making this gem work for many apps then
# that config will go here.
module Logmein

  # The name of the model as a string. Defaults to User as most apps
  # use that but if your model is not User then specify another class name
  # in an application initializer.
  mattr_accessor :authenticated_model_name
  self.authenticated_model_name = 'User'

  # A named route that the user should be directed to after login
  mattr_accessor :login_destination
  self.login_destination = :root_url

  # A named route that the user should be directed to after logout
  mattr_accessor :logout_destination
  self.logout_destination = :root_url

  # Used internally to trigger the request saving and redirect to login.
  # can be used by the application if it is opting out of the standard
  # security setup but wants the same handling when doing it's own
  # checking.
  class NotAuthenticated < StandardError; end
end

require 'logmein/controller_integration'
require 'logmein/authlogic_integration'
require 'logmein/engine'
