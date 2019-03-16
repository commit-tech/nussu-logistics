class AddItemRefToBookings < ActiveRecord::Migration[5.0]
  def change
    add_reference :bookings, :item, foreign_key: true
  end
end
