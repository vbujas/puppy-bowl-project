class ChangeAgeFormatInPuppies < ActiveRecord::Migration
  def change

  	 change_column :puppies, :PUPPY_AGE, :string
  end
end
