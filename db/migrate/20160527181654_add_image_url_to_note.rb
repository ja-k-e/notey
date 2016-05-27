class AddImageUrlToNote < ActiveRecord::Migration
  def change
    add_column :notes, :image_url, :string
  end
end
