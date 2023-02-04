# frozen_string_literal: true

FactoryBot.define do
  factory :onboarding do
    association :employee
    state { "pending" }
    subscribe { false }

    trait :subscribed do
      subscribe { true }
    end

    trait :in_progress do
      state { "in_progress" }
    end

    trait :completed do
      state { "completed" }
    end
  end
end

# == Schema Information
#
# Table name: onboardings
#
#  id          :bigint           not null, primary key
#  state       :integer          default("pending"), not null
#  subscribe   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  employee_id :bigint
#
# Indexes
#
#  index_onboardings_on_employee_id  (employee_id)
#
