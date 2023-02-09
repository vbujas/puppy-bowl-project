class AddVoteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vote, :string
  end
end
