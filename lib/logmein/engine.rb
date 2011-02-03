class Logmein::Engine < Rails::Engine

  config.to_prepare do |*args|
    # Inject our goodness into all controllers
    ActionController::Base.send :include, Logmein::ControllerIntegration
  end

end
