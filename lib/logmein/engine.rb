class Logmein::Engine < Rails::Engine

  initializer 'logmein.setup' do
    # Apply security to all controllers
    ActiveSupport.on_load(:action_controller) do
      include Logmein::ControllerIntegration
    end
  end

  config.after_initialize do
    # Determine aliased method name based on authenticated model
    alt_method = "current_#{Logmein.authenticated_model_name.underscore}".to_sym

    # If authenticated model is User then allow current_user to
    # alias authenticated_record for more readable code.
    ActionController::Base.send :alias_method, alt_method, :authenticated_record
    ActionController::Base.send :helper_method, alt_method

    # If authenticated model is User then allow current_user? to
    # alias authenticated_record? for more readable code.
    ActionController::Base.send :alias_method, "#{alt_method}?".to_sym, :authenticated_record?
    ActionController::Base.send :helper_method, "#{alt_method}?".to_sym
  end

end
