class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.datetime :begin_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
