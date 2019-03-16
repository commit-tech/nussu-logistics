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

require 'rails_helper'

RSpec.describe Booking, type: :model do
  it { should belong_to(:user) }
  
  it 'validates that quantity is a number and greater than 0' do
    Timecop.freeze(2000)

    booking = Booking.new(description: 'Non-number',
                          quantity: 'two',
                          start_time: DateTime.new(2100),
                          end_time: DateTime.new(2200))
    expect(booking).to be_invalid
    expect(booking.errors[:quantity]).to include('is not a number')

    booking = Booking.new(description: 'Negative quantity',
                          quantity: -1,
                          start_time: DateTime.new(2100),
                          end_time: DateTime.new(2200))
    expect(booking).to be_invalid
    expect(booking.errors[:quantity]).to include('must be greater than 0')

    Timecop.return
  end

  it 'validates that start time is at least one hour away from now' do
    Timecop.freeze(2000)

    booking = Booking.new(description: 'Late',
                          quantity: 10,
                          start_time: DateTime.now + Rational(1/48),
                          end_time: DateTime.new(2200))
    expect(booking).to be_invalid
    expect(booking.errors[:booking]).to include('must be done at least one hour before')

    Timecop.return
  end 

  it 'validates that end time is later than start time' do
    Timecop.freeze(2000)

    booking = Booking.new(description: 'Late',
                          quantity: 10,
                          start_time: DateTime.now.next_day(100),
                          end_time: DateTime.now.next_day(50))
    expect(booking).to be_invalid
    expect(booking.errors[:end_time]).to include('must be later than start time')

    Timecop.return
  end
end
