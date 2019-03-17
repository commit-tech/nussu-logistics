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

require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:quantity) }
  subject { create(:item) }
  it { should validate_uniqueness_of(:name).case_insensitive }
end
