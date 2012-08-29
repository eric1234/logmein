require 'test_helper'

class SessionTest < ActiveSupport::TestCase

  # Make sure everybody knows who everybody else is and something other
  # than User can be used as the authenticated model.
  test 'dynamically determined authenticated model' do
    assert_equal Session, User.session_class
    assert_equal 'User', Session.klass_name

    Logmein.authenticated_model_name = 'Account'
    assert_equal Session, Account.session_class
    assert_equal 'Account', Session.klass_name
  end

end

# For the alternate authenticated model
ActiveRecord::Base.connection.create_table :accounts, :force => true do |t|
  t.string :email, :null => false
  t.string :crypted_password, :password_salt, :persistence_token
end
class Account < ActiveRecord::Base; acts_as_authentic end
