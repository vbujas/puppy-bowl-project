class AddFieldGoalsToPuppies < ActiveRecord::Migration
  def change

  	  add_column :puppies, :score_field_goals, :integer, :default => 0
  end
end
