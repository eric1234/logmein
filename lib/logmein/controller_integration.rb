# Security applied to all controllers.
module Logmein::ControllerIntegration
  extend ActiveSupport::Concern

  included do
    helper_method :authenticated_record
    before_filter :authenticate
  end

  protected

  # Returns current authenticated user. Note that is this aliased as
  # current_[class_name]. So if the authenticated object is a User then you
  # can use "current_user"
  def authenticated_record
    return @__authenticated_record if
      instance_variable_defined? :@__authenticated_record
    @__authenticated_record = begin
      session = ::Session.find
      session && session.record
    end
  end

  private

  # All actions require an authenticated record UNLESS it is in the
  # PUBLIC_ACTIONS constant.
  def authenticate
    # If path not define then we must be in an isolated engine. In that
    # case security doesn't apply (it does say it wants to be isolated).
    return unless respond_to? :login_url

    is_public = self.class.const_defined?('PUBLIC_ACTIONS') &&
      self.class::PUBLIC_ACTIONS.collect(&:to_sym).include?(action_name.to_sym)
    unless is_public || authenticated_record
      session[:return_to] = params if request.get?
      redirect_to login_url
    end
  end
end
