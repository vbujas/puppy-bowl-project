class CreatePuppyTeams < ActiveRecord::Migration
  def change
    create_table :puppy_teams do |t|
      t.belongs_to :puppy
      t.belongs_to :team
      t.timestamps
    end
  end
end
