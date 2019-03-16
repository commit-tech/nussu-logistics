# frozen_string_literal: true
# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  description :text             default(""), not null
#  quantity    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
<<<<<<< HEAD
    factory :item do
      name { "Dummy" }
      description { "Dummy Item" }
      quantity { 2 }
    end
end 
=======
  factory :item do
    name { "Dummy" }
    description { "Dummy Item" }
    quantity { 2 }
  end
end
>>>>>>> 63cab59e523b6dbbcdcd9cfb5287715ca200f28f
