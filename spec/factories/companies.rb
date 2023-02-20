# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    email { Faker::Internet.unique.email(domain: "example") }
    website { Faker::Internet.url }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
    # TODO: Add logo
  end
end

# == Schema Information
#
# Table name: companies
#
#  id                  :bigint           not null, primary key
#  email               :string           not null
#  name                :string           not null
#  phone               :string
#  website             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  finance_approver_id :bigint
#  public_id           :string(19)       not null
#
# Indexes
#
#  index_companies_on_email                (email) UNIQUE
#  index_companies_on_finance_approver_id  (finance_approver_id)
#  index_companies_on_public_id            (public_id) UNIQUE
#
