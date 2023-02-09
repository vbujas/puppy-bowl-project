class AddUsernameToUsers < ActiveRecord::Migration
  def change
    unless column_exists? :users, :username
      add_column :users, :username, :string
      add_index :users, :username, unique: true
    end
  end
end
