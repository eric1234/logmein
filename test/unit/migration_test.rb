require 'test_helper'

class MigrationTest < ActiveSupport::TestCase

  # Is the migration smart enough to create the table if needed with the
  # right table name in addition to the standard fields.
  test 'smart migration' do
    ActiveRecord::Base.connection.table_exists? 'users'
    assert_equal %w(email crypted_password),
      %w(email crypted_password) & User.column_names
  end

end