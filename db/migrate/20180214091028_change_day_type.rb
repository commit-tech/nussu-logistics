class ChangeDayType < ActiveRecord::Migration[5.0]
  def change
    change_column :timeslots, :day, :text
  end
end
