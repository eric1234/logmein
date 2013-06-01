Rails.application.routes.draw do
  get 'login', :to => 'sessions#new'
  get 'logout', :to => 'sessions#destroy'
  resource :session, :only => [:new, :create, :destroy]
end
