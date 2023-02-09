class AddBigPicToPuppies < ActiveRecord::Migration
  def change
  	  add_column :puppies, :big_pic, :string
  end
end
