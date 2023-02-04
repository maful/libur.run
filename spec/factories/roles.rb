# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "role_#{n}" }
  end
end

# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  public_id  :string(19)       not null
#
# Indexes
#
#  index_roles_on_name       (name) UNIQUE
#  index_roles_on_public_id  (public_id) UNIQUE
#
