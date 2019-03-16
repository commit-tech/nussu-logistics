class MakeNameUniqueInItems < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext
    change_column :items, :name, :citext
    add_index :items, :name, unique: true
  end
end
