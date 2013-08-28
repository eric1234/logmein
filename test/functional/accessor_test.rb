require 'test_helper'

class AccessorControllerTest < ActionController::TestCase

  self.custom_routes = proc do
    get 'current_XXXX' => 'accessor#current_XXXX'
    get 'auth_record' => 'accessor#auth_record'
  end

  def setup
    Session.create create_user
  end

  test 'authenticated_record' do
    get :auth_record
    assert_response :success
    assert_equal 'joe@example.com', @response.body
  end

  test 'current_XXXX alias' do
    get :current_XXXX
    assert_response :success
    assert_equal 'joe@example.com', @response.body
  end

end

# An example controller for our test
class AccessorController < ActionController::Base
  def current_XXXX; render :text => current_user.email end
  def auth_record; render :text => authenticated_record.email end
end
