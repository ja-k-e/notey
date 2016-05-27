class AddLimitToNoteValues < ActiveRecord::Migration
  def change
    change_column :notes, :message, :string, limit: 150
    change_column :notes, :image_url, :string, limit: 255
  end
end
