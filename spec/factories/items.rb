# frozen_string_literal: true
# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :citext           default(""), not null
#  description :text             default(""), not null
#  quantity    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_items_on_name  (name) UNIQUE
#

FactoryBot.define do
  factory :item do
    name { "Dummy" }
    description { "Dummy Item" }
    quantity { 2 }
  end
end
