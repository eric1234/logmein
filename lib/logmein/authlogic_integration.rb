module Logmein::AuthlogicIntegration
  extend ActiveSupport::Concern

  module ClassMethods

    # By default Authlogic assumes the session class is named based on the
    # class being authenticated (User -> UserSession). If an app does not follow
    # that assumption then the app must manually specify the session class.
    # Since our session class is simply called "Session" we do not follow that
    # default but we don't want every app to need to specify this. So we
    # override session_class to allow "Session" as the default if "UserSession"
    # cannot be loaded.
    def session_class(value=nil)
      const = "#{base_class.name}Session".constantize rescue Session
      rw_config(:session_class, value, const)
    end
  end

end