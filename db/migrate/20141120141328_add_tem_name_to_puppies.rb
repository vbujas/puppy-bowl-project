class AddTemNameToPuppies < ActiveRecord::Migration
  def change

  	  add_column :puppies, :team_name, :string
  end
end
