require 'test_helper'

class StoriesTest < ActionDispatch::IntegrationTest

  self.custom_routes = proc do
    match 'restricted' => 'access#restricted'
    match 'dashboard' => 'access#dashboard'
    match 'open' => 'access#open'
  end

  def setup
    # Make us go to the login page after logout
    Logmein.logout_destination = :login_path

    # Provide a default page other than restricted
    Logmein.login_destination = :dashboard_path
  end

  test 'un-authenticated user wants to access a restricted page' do
    # So user can login successfully.
    create_user

    # Request restricted page and get back Login page
    visit '/restricted'
    assert page.has_content? 'Login'

    # See if we can access the page after login
    login
    assert page.has_content? 'restricted'
  end

  test 'authenticated user wants to logout' do
    # So user can login successfully.
    create_user

    # So we are already logged in
    visit '/login'
    login

    # Make sure the system knows we are logged in and acts accordingly
    visit '/restricted'
    assert page.has_content? 'restricted'

    # Ask it to logout and make sure we got the right destination
    visit '/logout'
    assert page.has_content? 'Login'

    # When trying to access a restricted page we are prompted for login.
    visit '/restricted'
    assert page.has_content? 'Login'
  end

  test 'un-authorized user wants to login without a specific page desired' do
    # So user can login successfully.
    create_user

    # Request the login page (without another page first)
    visit '/login'

    # See if we are directed to the configured page
    login
    assert page.has_content? 'dashboard'
  end

  test 'un-authorized user wants to visit a public page' do
    visit '/open'
    assert page.has_content? 'open'
  end

  private

  def login
    fill_in 'E-mail', :with => 'joe@example.com'
    fill_in 'Password', :with => 'password'
    click_button 'Login'
  end

end

# An example controller for our test
class AccessController < ActionController::Base
  PUBLIC_ACTIONS = %w(open)

  def restricted; render :text => 'restricted' end
  def dashboard; render :text => 'dashboard' end
  def open; render :text => 'open' end
end