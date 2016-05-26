class AddSlackUserToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :slack_user, :string
  end
end
