class AddCcaToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cca, :string, null: false
  end
end
