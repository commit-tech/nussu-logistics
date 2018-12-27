# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: duties
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  timeslot_id     :integer
#  date            :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  request_user_id :integer
#  free            :boolean          default(FALSE), not null
#
# Indexes
#
#  index_duties_on_timeslot_id                       (timeslot_id)
#  index_duties_on_user_id                           (user_id)
#  index_duties_on_user_id_and_timeslot_id_and_date  (user_id,timeslot_id,date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (timeslot_id => timeslots.id)
#  fk_rails_...  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class Duty < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :request_user, class_name: 'User', optional: true,
                            inverse_of: :duties
  belongs_to :timeslot
  has_one :time_range, through: :timeslot
  has_one :place, through: :timeslot
  # validates_uniqueness_of :date, scope = [:timeslot_id, :user_id]
  scope :ordered_by_start_time,
        -> { joins(:time_range).order('time_ranges.start_time') }

  def self.generate(start_date, end_date)
    (start_date..end_date).each do |date|
      day = Date::DAYNAMES[date.wday]
      Timeslot.where(day: day).find_each do |ts|
        duty = Duty.find_or_create_by(timeslot: ts, date: date)
        duty.user = ts.default_user
        puts(duty)
        duty.save
      end
    end
  end
end
