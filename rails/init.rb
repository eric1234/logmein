require 'logmein/controller_integration'
config.to_prepare do
  ApplicationController.send :include, Logmein::ControllerIntegration
end
