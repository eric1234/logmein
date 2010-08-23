class UserSessionsController < ApplicationController
  PUBLIC_ACTIONS = %w(new create)

  def new
    @user_session = UserSession.new
  end

  def create
    next_url = params[:return_to] || session[:return_to] || Logmein.return_to || root_url
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      session.delete :return_to
      flash[:notice] = "Successfully logged in."
      redirect_to next_url
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    reset_session
    flash[:notice] = "Successfully logged out."
    redirect_to(params[:next] || root_url)
  end
end
