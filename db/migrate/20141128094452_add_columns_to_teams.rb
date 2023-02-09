class AddColumnsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :pup1, :integer
    add_column :teams, :pup2, :integer
    add_column :teams, :pup3, :integer
  end
end
