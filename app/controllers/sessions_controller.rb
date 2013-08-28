# Standard login/logout using REST-based design.
class SessionsController < ApplicationController
  PUBLIC_ACTIONS = %w(new create)

  # Login form might be hosted elsewhere (brochure site). Protection
  # not really needed for this action anyway.
  skip_before_filter :verify_authenticity_token, only: :create

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
