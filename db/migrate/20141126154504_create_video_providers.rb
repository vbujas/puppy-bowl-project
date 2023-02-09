class CreateVideoProviders < ActiveRecord::Migration
  def change
    create_table :video_providers do |t|
      t.string :name

      t.timestamps
    end
  end
end
