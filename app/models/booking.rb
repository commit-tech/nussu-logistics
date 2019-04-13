# == Schema Information
#
# Table name: bookings
#
#  id          :integer          not null, primary key
#  status      :integer
#  description :text
#  start_time  :datetime
#  end_time    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  quantity    :integer
#  user_id     :integer
#  item_id     :integer
#
# Indexes
#
#  index_bookings_on_item_id  (item_id)
#  index_bookings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (user_id => users.id)
#

class Booking < ApplicationRecord
  STATUSES = %i[pending approved rejected].freeze
  enum status: STATUSES

  belongs_to :user
  belongs_to :item

  validates :quantity, numericality:{greater_than: 0}
  validates :item_id, presence: true
  validates :user_id, presence: true
  validates :start_time, uniqueness: { scope: [:item_id, :user_id, :end_time] }
  validate :booking_must_be_at_least_one_hour_before
  validate :end_time_must_be_later_than_start_time
  validate :enough_items

  attr_accessor :start_date
  attr_accessor :start_timing
  attr_accessor :end_date
  attr_accessor :end_timing

  def booking_must_be_at_least_one_hour_before
    if self.start_time < DateTime.now + 1.hours
      self.errors.add(:booking, 'must be done at least one hour before')
    end
  end

  def end_time_must_be_later_than_start_time
    if self.start_time >= self.end_time
      self.errors.add(:end_time, 'must be later than start time')
    end  
  end

  def enough_items
    used = Booking.where(item_id: item_id, status: "approved").where('? BETWEEN ? AND ?', self.start_time, start_time, end_time).size
    available = self.item.quantity - used

    if available < self.quantity then
      self.errors.add(:quantity, "must be at most the number available in time range. Number available in range: #{self.item.quantity}")
    elsif not available.between?(0, self.item.quantity) then
      self.errors.add(:base, "Available quantity not in range 0 - #{self.item.quantity}.")
    end
  end
end
