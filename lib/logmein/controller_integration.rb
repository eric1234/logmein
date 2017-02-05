# Security applied to all controllers.
module Logmein::ControllerIntegration
  extend ActiveSupport::Concern

  included do
    helper_method :authenticated_record, :authenticated_record?, :logged_in?
    before_action :check_authentication
    rescue_from Logmein::NotAuthenticated, :with => :authenticate
  end

  protected

  # Returns current authenticated user. Note that is this aliased as
  # current_[class_name]. So if the authenticated object is a User then
  # you can use "current_user"
  def authenticated_record
    return @__authenticated_record if
      instance_variable_defined? :@__authenticated_record
    @__authenticated_record = begin
      session = ::Session.find
      session && session.record
    end
  end
  alias_method :authenticated_record?, :authenticated_record
  alias_method :logged_in?, :authenticated_record

  private

  # All actions require an authenticated record UNLESS it is in the
  # PUBLIC_ACTIONS constant.
  def check_authentication
    # If path not define then we must be in an isolated engine. In that
    # case security doesn't apply (it does say it wants to be isolated).
    return unless respond_to? :login_url

    raise Logmein::NotAuthenticated unless
      is_public_action? || authenticated_record
  end

  # Look for the constant PUBLIC_ACTIONS in the current class. If
  # found and if the current action is in that list then return true.
  # Otherwise return false.
  def is_public_action?
    klass = self.class
    return false unless klass.const_defined? 'PUBLIC_ACTIONS'
    klass::PUBLIC_ACTIONS.collect(&:to_s).include? action_name
  end

  # Will save the current request and redirect the user to login. After
  # login the user will be redirected back to the request. Note that
  # only GET requests can be saved since we cannot redirect to a POST
  # (and probably don't want to even if we could hack it).
  def authenticate(exception)
    session[:return_to] = request.fullpath if request.get?
    redirect_to login_url
  end
end
