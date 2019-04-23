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

FactoryBot.define do
  factory :booking do
    association :user, factory: :user
    association :item, factory: :item

    status { 1 }
    quantity { 1 }
    description { "MyText" }
    start_time { "2000-01-01 09:00:00" }
    end_time { "2000-01-15 10:00:00" }
  end
end
