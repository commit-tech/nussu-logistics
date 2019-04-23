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
  validate :duplicate_booking
  validate :booking_must_be_at_least_one_hour_before, unless: :skip_start_time_validation
  validate :end_time_must_be_later_than_start_time
  validate :enough_items

<<<<<<< HEAD
  attr_accessor :start_date
  attr_accessor :start_time_only
  attr_accessor :end_date
  attr_accessor :end_time_only
=======
  attr_accessor :skip_start_time_validation
>>>>>>> 58e4749c2e94ecf23dbc34414bc7446a676194cf

  def booking_must_be_at_least_one_hour_before
    return unless self.errors.blank?

    if self.start_time < DateTime.now + 1.hours
      self.errors.add(:booking, 'must be done at least one hour before')
    end
  end

  def end_time_must_be_later_than_start_time
    return unless self.errors.blank?

    if self.start_time >= self.end_time
      self.errors.add(:end_time, 'must be later than start time')
    end  
  end

  def duplicate_booking
    return unless self.errors.blank?

    duplicates = Booking.where(item_id: self.item_id, user_id: self.user_id, start_time: self.start_time, end_time: self.end_time, status: 0)
                        .where.not(id: self.id)

    if duplicates.any?
      self.errors.add(:base, "Similar pending booking exists, please check")
    end  
  end

  def enough_items
    return unless self.errors.blank?

    approvedBookings = Booking.where(item_id: self.item_id)
                              .where.not(id: self.id)
                              .order(:start_time)
                              .select(:start_time, :end_time, :quantity)
                              
    curr = self.start_time
    maxUsed = 0

    while curr < self.end_time do
      used = approvedBookings.where("start_time <= :curr AND end_time > :curr", curr: curr).sum(:quantity)
      maxUsed = maxUsed < used ? used : maxUsed

      next_booking = approvedBookings.where.not("start_time <= :curr", curr: curr).first
      if next_booking.nil?
        curr = self.end_time
      else
        curr = next_booking.start_time
      end  
    end

    available = self.item.quantity - maxUsed

    if available < self.quantity then
      self.errors.add(:quantity, "must be at most the number available in time range. Number available in range: #{self.item.quantity}")
    elsif not available.between?(0, self.item.quantity) then
      self.errors.add(:base, "Available quantity not in range 0 - #{self.item.quantity}.")
    end
  end
end
