module Logmein::ControllerIntegration
  def self.included(mod)
    mod.extend ActiveSupport::Memoizable
    mod.memoize :current_user
    mod.helper_method :current_user
    mod.before_filter :authenticate
  end

  protected

  def current_user
    session = ::UserSession.find
    session && session.record
  end

  private

  def authenticate
    is_public = self.class.const_defined?('PUBLIC_ACTIONS') &&
      self.class::PUBLIC_ACTIONS.collect(&:to_sym).include?(action_name.to_sym)
    unless is_public || current_user
      session[:return_to] = params
      redirect_to login_url
    end
  end
end