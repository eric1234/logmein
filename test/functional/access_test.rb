require 'test_helper'

class AccessControllerTest < ActionController::TestCase

  self.custom_routes = proc do
    match 'open' => 'access#open'
    match 'restricted' => 'access#restricted'
  end

  test 'public actions accessible without login' do
    get :open
    assert_response :success
    assert_equal 'open', @response.body
  end

  test 'restricted action redirects if not logged in' do
    get :restricted
    assert_redirected_to login_url
    assert_equal(
      {'controller' => 'access', 'action' => 'restricted'},
      session['return_to']
    )

    # Returning data not set if not GET request
    session['return_to'] = nil
    post :restricted
    assert_nil session['return_to']
  end

  test 'resticted action accessible if logged in' do
    Session.create create_user

    get :restricted
    assert_response :success
    assert_equal 'restricted', @response.body
  end
end

# An example controller for our test
class AccessController < ActionController::Base
  PUBLIC_ACTIONS = %w(open)

  def open; render :text => 'open' end
  def restricted; render :text => 'restricted' end
end
