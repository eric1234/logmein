class Logmein::Engine < Rails::Engine

  initializer 'logmein.setup' do
    # Apply security to all controllers
    ActiveSupport.on_load(:action_controller) do
      include Logmein::ControllerIntegration
    end
  end

  config.after_initialize do
    # Implement current_[class_name] aliasing
    alt_method = "current_#{Logmein.authenticated_model_name.underscore}".to_sym
    ActionController::Base.send :alias_method, alt_method, :authenticated_record
    ActionController::Base.send :helper_method, alt_method

    # Mixin AFTER Authlogic loads
    ActiveRecord::Base.send :include, Logmein::AuthlogicIntegration
  end

end
