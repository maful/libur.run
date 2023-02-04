# frozen_string_literal: true

FactoryBot.define do
  factory :claim_type do
    sequence(:name) { |n| "Claim Type #{n}" }
    description { Faker::Lorem.sentence(word_count: 3) }
    status { true }

    trait :inactive do
      status { false }
    end
  end
end

# == Schema Information
#
# Table name: claim_types
#
#  id          :bigint           not null, primary key
#  description :string(100)
#  name        :string(50)       not null
#  status      :boolean          default(TRUE)
#  year        :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  public_id   :string(19)       not null
#
# Indexes
#
#  index_claim_types_on_public_id      (public_id) UNIQUE
#  index_claim_types_on_year_and_name  (year,name) UNIQUE
#
