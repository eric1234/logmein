class Session < Authlogic::Session::Base
  unloadable

  # Dynamically determine from Logmein config. Also lets the model know
  # the model for the session.
  def self.klass_name
    Logmein.authenticated_model_name.tap do |kls|
      kls.constantize.session_class = self if Object.const_defined? kls
    end
  end
end
