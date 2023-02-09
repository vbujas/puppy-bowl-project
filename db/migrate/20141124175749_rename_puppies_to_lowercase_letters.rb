class RenamePuppiesToLowercaseLetters < ActiveRecord::Migration
  def change
    rename_column :puppies, :PUPPY_NAME, :name
    rename_column :puppies, :PUPPY_BREED, :breed
    rename_column :puppies, :PUPPY_SEX, :sex
    rename_column :puppies, :PUPPY_AGE, :age
    rename_column :puppies, :PUPPY_FUN_FACT, :fun_fact
    rename_column :puppies, :SCORE_TOUCHDOWNS, :score_touchdowns
    rename_column :puppies, :SCORE_PENALTIES, :score_penalties
    rename_column :puppies, :SCORE_TAKEAWAYS, :score_takeaways
    rename_column :puppies, :SCORE_TACKLES, :score_tackles
    rename_column :puppies, :PUPPY_PIC, :pic
  end
end
