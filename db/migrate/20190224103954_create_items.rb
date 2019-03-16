class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|

      t.string :name,      null: false, default: ""
      t.text :description, null: false, default: ""
      t.integer :quantity,     null: false, default: ""

      t.timestamps null: false
    end
  end
end
