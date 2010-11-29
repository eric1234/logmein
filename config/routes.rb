Rails.application.routes.draw do
  scope Logmein.route_scope do
    match 'login', :to => 'sessions#new'
    match 'logout', :to => 'sessions#destroy'
    resource :session, :only => [:new, :create, :destroy]
  end
end
