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
    return unless self.errors.blank?

    approvedBookings = Booking.select(:start_time, :end_time, :quantity, :item_id, :id, :status)
                              .where(item_id: self.item_id)
                              .where.not(id: self.id)
                              
    curr = self.start_time
    maxUsed = 0

    while curr < self.end_time do
      used = approvedBookings.where("start_time <= :curr AND end_time > :curr", curr: curr).sum(:quantity)
      maxUsed = maxUsed < used ? used : maxUsed

      curr = curr + 30.minutes
    end

    available = self.item.quantity - maxUsed

    if available < self.quantity then
      self.errors.add(:quantity, "must be at most the number available in time range. Number available in range: #{self.item.quantity}")
    elsif not available.between?(0, self.item.quantity) then
      self.errors.add(:base, "Available quantity not in range 0 - #{self.item.quantity}.")
    end
  end
end
