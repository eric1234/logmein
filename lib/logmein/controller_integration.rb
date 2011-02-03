module Logmein::ControllerIntegration
  extend ActiveSupport::Concern

  included do
    # To prevent double initialization
    return if method_defined? :_unmemoized_authenticated_record

    extend ActiveSupport::Memoizable
    memoize :authenticated_record
    helper_method :authenticated_record
    before_filter :authenticate

    # To allow current_user to be an alias of authenticated_record
    alt_method = "current_#{Logmein.authenticated_model_name.underscore}".to_sym
    alias_method alt_method, :authenticated_record
    helper_method alt_method
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
