Rails.application.routes.draw do
  match 'login', :to => 'sessions#new'
  match 'logout', :to => 'sessions#destroy'
  resource :session, :only => [:new, :create, :destroy]
end
