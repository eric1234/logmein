class AddLoginFields < ActiveRecord::Migration

  def up
    # Add table in case app has not already done so to save the app a step
    # of defining a migration just to define the table.
    create_table table_name do |u|
      u.string :email, :null => false
    end unless ActiveRecord::Base.connection.table_exists? table_name

    # Add the fields we need to authenticate a user.
    change_table table_name do |u|
      u.string :crypted_password, :password_salt, :persistence_token
    end
  end

  def down
    change_table table_name do |u|
      u.remove :crypted_password, :password_salt, :persistence_token
    end
    # NOTE: Don't remove table since we don't know who added it.
  end

  private

  def table_name
    Logmein.authenticated_model_name.downcase.pluralize.to_sym
  end

end