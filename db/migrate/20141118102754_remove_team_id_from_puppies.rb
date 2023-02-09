class RemoveTeamIdFromPuppies < ActiveRecord::Migration
  def change
    remove_column :puppies, :team_id
  end
end
