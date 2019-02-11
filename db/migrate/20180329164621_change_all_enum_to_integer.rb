class ChangeAllEnumToInteger < ActiveRecord::Migration[5.0]
  def change
    remove_column :timeslots, :day
    add_column :timeslots, :day, :integer
  end
end
