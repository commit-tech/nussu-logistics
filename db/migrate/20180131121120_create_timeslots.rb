class CreateTimeslots < ActiveRecord::Migration[5.0]
  def change
    create_table :timeslots do |t|
      t.date :day
      t.references :user, foreign_key: true
      t.references :time_range, foreign_key: true
      t.timestamps
    end
  end
end
