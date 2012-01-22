require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  self.custom_routes = proc do
    match 'home' => proc {[200, {}, ['Home page']]}
    match 'restricted' => proc {[200, {}, ['Restricted page']]}
    root :to => proc {[200, {}, ['Home page']]}
  end

  test 'login form' do
    get :new

    # A page comes up
    assert_response :success

    # That page has some sort of form to create a new session.
    assert_select "form[action=#{session_path}]" do
      assert_select "input[type=email][name='session[email]']"
      assert_select "input[type=password][name='session[password]']"
    end

    # The "Forgot Password" hook is disabled
    assert_select 'a', :text => 'Forgot Password', :count => 0

    # Forgot password hook is now enabled.
    with_routing do |set|
      set.draw do
        resource :session, :only => [:new, :create]
        resource :password, :only => :new
      end
      get :new
      assert_select 'a', :text => 'Forgot Password'
    end
  end

  test 'success' do
    u = create_user

    assert_nil Session.find

    # Basic login assume default "root_url" redirect
    login
    assert_redirected_to root_url
    assert !Session.find.new_session?
    assert_equal u, Session.find.record
    assert_no_match /expires/, @response.headers['Set-Cookie']
    Session.find.destroy

    # Login with "remember me"
    login :remember_me => '1'
    assert_match /expires/, @response.headers['Set-Cookie']
    Session.find.destroy

    # Application can configure alternate location
    Logmein.login_destination = :home_url
    login
    assert_redirected_to home_url
    Session.find.destroy

    # Alternate location can be set per session
    # (to allow returning to page requested when login triggered)
    # NOTE: login_destination still set to home but it won't follow it
    request.session[:return_to] = restricted_url
    login
    assert_redirected_to restricted_url
  end

  test 'failure' do
    # User doesn't exist
    login
    assert_response :success
    assert_select "form[action=#{session_path}]" do
      assert_select "input[type=email][name='session[email]'][value=joe@example.com]"
      assert_select "input[type=password][name='session[password]']"
    end

    # User exists, but password wrong
    create_user
    login :password => 'wrong'
    assert_response :success
    assert_select "form[action=#{session_path}]" do
      assert_select "input[type=email][name='session[email]'][value=joe@example.com]"
      assert_select "input[type=password][name='session[password]']"
    end
  end

  test 'logout' do
    u = create_user
    Session.create u

    # Assume standard default 'root_url' redirect
    delete :destroy
    assert_nil Session.find
    assert_redirected_to root_url
    Session.create u

    # Application can configure alternate location
    Logmein.logout_destination = :home_url
    delete :destroy
    assert_redirected_to home_url
  end

  private

  def login(attrs={})
    attrs.reverse_merge! :email => 'joe@example.com', :password => 'password'
    post :create, :session => attrs
  end

end