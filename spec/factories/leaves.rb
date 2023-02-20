# frozen_string_literal: true

FactoryBot.define do
  factory :leave do
    association :leave_type
    association :manager, factory: :employee
    association :employee
    comment { nil }
    approval_status { :pending }
    approval_date { nil }
    half_day { nil }
    half_day_time { nil }
    note do
      ["I will be going on vacation", "I need to take some time off for a medical procedure.",
       "I am requesting a leave of absence to take care of a personal matter.",].sample
    end
    start_date { Date.new(2023, 2, 23) }
    end_date { start_date + 1.day }
    year { Date.current.year }

    trait :half_day do
      half_day { true }
      half_day_time { ["AM", "PM"].sample }
      start_date { Date.new(2023, 2, 27) }
      end_date { start_date }
    end

    trait :approved do
      approval_status { :approved }
      approval_date { Time.current }
      comment { "Approved! Have a great time and come back refreshed." }
    end

    trait :denied do
      approval_status { :denied }
      approval_date { Time.current }
      comment { "Leave request denied. We have an important project coming up and we need all hands on deck." }
    end

    trait :canceled do
      approval_status { :canceled }
      approval_date { Time.current }
    end

    trait :taken do
      approval_status { :taken }
    end
  end
end

# == Schema Information
#
# Table name: leaves
#
#  id              :bigint           not null, primary key
#  approval_date   :datetime
#  approval_status :integer          not null
#  comment         :string(100)
#  end_date        :date             not null
#  half_day        :boolean          default(FALSE)
#  half_day_time   :string
#  note            :string(100)
#  number_of_days  :decimal(4, 2)    not null
#  start_date      :date             not null
#  year            :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  employee_id     :bigint
#  leave_type_id   :bigint
#  manager_id      :bigint
#  public_id       :string(19)       not null
#
# Indexes
#
#  index_leaves_on_employee_id    (employee_id)
#  index_leaves_on_leave_type_id  (leave_type_id)
#  index_leaves_on_manager_id     (manager_id)
#  index_leaves_on_year           (year)
#
# Foreign Keys
#
#  fk_rails_...  (manager_id => employees.id)
#
