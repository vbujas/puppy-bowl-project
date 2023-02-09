class AddAttachmentAvatarToUsers < ActiveRecord::Migration
  def self.up
    if Gem::Specification::find_all_by_name('paperclip').any?
      change_table :users do |t|
        t.attachment :avatar
      end
    end
  end

  def self.down
    remove_attachment :users, :avatar
  end
end
