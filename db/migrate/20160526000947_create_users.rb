class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :api_key
      t.boolean :admin, default: false

      t.timestamps null: false
    end

    add_index :users, :username, unique: true
  end
end
