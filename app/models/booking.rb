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
  validate :booking_must_be_at_least_one_hour_before
  validate :end_time_must_be_later_than_start_time
  #validate :enough_items

  def booking_must_be_at_least_one_hour_before
    if self.start_time < DateTime.now + Rational(1,24)
      self.errors.add(:booking, 'must be done at least one hour before')
    end
  end

  def end_time_must_be_later_than_start_time
    if self.start_time >= self.end_time
      self.errors.add(:end_time, 'must be later than start time')
    end  
  end

  def enough_items
    bookings = Booking.where(item_id: item_id, status: approved)
    max = 0

    curr = self.start_time
    while curr < self.end_time
      num = 0
      bookings.each do |b|
        if curr >= b.start_time && curr < b.end_time
          num = num + 1
        end 
      end
      
      curr = curr + Rational(1, 48)
      max = max > num ? max : num
    end  
    
    total = Item.find(item_id).quantity
    available = total - max
    
    if total < self.quantity
      self.errors.add(:quantity, 'must be at most the number available in time range')
    end
  end
end
