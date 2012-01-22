# Standard login/logout using REST-based design.
class SessionsController < ApplicationController
  PUBLIC_ACTIONS = %w(new create)

  # The login form
  def new
    @session = Session.new
  end

  # Process a login
  def create
    next_url = session[:return_to] || send(Logmein.login_destination)
    @session = Session.new params[:session]
    if @session.save
      session.delete :return_to
      flash[:notice] = "Successfully logged in."
      redirect_to next_url
    else
      render :action => 'new'
    end
  end

  # Logout
  def destroy
    @session = Session.find
    @session.destroy
    reset_session
    flash[:notice] = "Successfully logged out."
    redirect_to send(Logmein.logout_destination)
  end
end
