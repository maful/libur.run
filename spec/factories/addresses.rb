# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    line_1 { Faker::Address.street_address }
    line_2 { Faker::Address.secondary_address }
    country_code { Faker::Address.country_code }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    for_employee

    trait :for_employee do
      association :addressable, factory: :employee
    end

    trait :for_company do
      association :addressable, factory: :company
    end
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  addressable_type :string           not null
#  city             :string           not null
#  country_code     :string(2)        not null
#  line_1           :string           not null
#  line_2           :string
#  state            :string           not null
#  zip              :string(10)       not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  addressable_id   :bigint           not null
#  public_id        :string(19)       not null
#
# Indexes
#
#  index_addresses_on_addressable  (addressable_type,addressable_id) UNIQUE
#  index_addresses_on_public_id    (public_id) UNIQUE
#
