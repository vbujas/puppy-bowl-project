class AddVideoProviderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :video_provider, :string
  end
end
