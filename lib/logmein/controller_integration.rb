module Logmein::ControllerIntegration
  def self.included(mod)
    # To prevent double initialization
    return if mod.method_defined? :_unmemoized_authenticated_record

    mod.extend ActiveSupport::Memoizable
    mod.memoize :authenticated_record
    mod.helper_method :authenticated_record
    mod.before_filter :authenticate
  end

  protected

  def authenticated_record
    session = ::Session.find
    session && session.record
  end

  private

  def authenticate
    is_public = self.class.const_defined?('PUBLIC_ACTIONS') &&
      self.class::PUBLIC_ACTIONS.collect(&:to_sym).include?(action_name.to_sym)
    unless is_public || authenticated_record
      session[:return_to] = params
      redirect_to login_url
    end
  end
end
