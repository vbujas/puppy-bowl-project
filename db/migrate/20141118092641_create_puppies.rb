class CreatePuppies < ActiveRecord::Migration
  def change
    create_table :puppies do |t|
      t.integer :TEAM_ID
      t.string :PUPPY_NAME
      t.string :PUPPY_BREED
      t.string :PUPPY_SEX
      t.integer :PUPPY_AGE
      t.string :PUPPY_FUN_FACT
      t.integer :SCORE_TOUCHDOWNS, :null => false, :default => 0
      t.integer :SCORE_PENALTIES, :null => false, :default => 0
      t.integer :SCORE_TAKEAWAYS, :null => false, :default => 0
      t.integer :SCORE_TACKLES, :null => false, :default => 0
      t.string :PUPPY_PIC

      t.timestamps
    end
  end
end
