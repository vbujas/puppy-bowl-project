class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :TEAM_NAME
      t.string :TEAM_DESCRIPTION
      t.belongs_to :user
      t.timestamps
    end
  end
end
