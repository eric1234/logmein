class AddLoginFields < ActiveRecord::Migration

  def self.up
    # In general the users table should already exist but just in
    # case it does not go ahead and create it.
    create_table :users do |u|
      u.string :email, :null => false
    end unless ActiveRecord::Base.connection.table_exists? :users

    change_table :users do |u|
      u.string :crypted_password, :password_salt, :persistence_token
    end
  end

  def self.down
    change_table :users do |u|
      u.remove :crypted_password, :password_salt, :persistence_token
    end
    # NOTE: We do not remove the users table as we don't know if
    # we added it or if it was already there.
  end

end