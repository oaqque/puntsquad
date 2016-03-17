class AddAttachmentHerobgToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.attachment :herobg
    end
  end

  def self.down
    remove_attachment :posts, :herobg
  end
end
