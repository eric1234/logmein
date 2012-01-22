# So the app doesn't have to define the session class that AuthLogic defines.
# Since we only support one authenticating class and we don't know what the
# name of that class will be we just call this class "Session" instead of
# following the Authlogic convention (i.e. UserSession).
class Session < Authlogic::Session::Base
  unloadable # To avoid reloading of every request in development.

  # Dynamically determine from Logmein config since we are not following
  # naming convention.
  def self.klass_name
    Logmein.authenticated_model_name
  end
end
