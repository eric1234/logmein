class Logmein::Engine < Rails::Engine

  config.to_prepare do

    # Inject our goodness into all controllers
    ApplicationController.send :include, Logmein::ControllerIntegration

    # Make sure the authenticated object is defined
    Session.klass rescue nil
    unless Object.const_defined? Session.klass_name
      Object.const_set Session.klass_name, Class.new(ActiveRecord::Base)
      Object.const_get(Session.klass_name).class_eval do
        unloadable
        acts_as_authentic
      end
    end
  end

end
