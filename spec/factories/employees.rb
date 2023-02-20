# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    association :account
    manager { nil }
    name { Faker::Name.name }
    birthday { Date.new(1999, 12, 31) }
    citizenship { Faker::Address.country_code }
    identity_number { Faker::IDNumber.valid }
    passport_number { nil }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    marital_status { Employee::MARITAL_STATUS_LIST.keys.sample }
    religion { Employee::RELIGION_LIST.keys.sample }
    status { "active" }
    start_date { Date.current - 1.year }
    position { Faker::Job.title }
    country_of_work { Faker::Address.country_code }

    trait :inactive do
      status { "inactive" }
    end

    trait :archived do
      status { "archived" }
    end

    transient do
      with_manager_assigned { true }
      with_manager_role { false }
      with_admin_role { false }
      with_address { false }
    end

    after :create do |employee, evaluator|
      if evaluator.with_manager_assigned
        employee.manager = create(:employee, with_manager_assigned: false, with_manager_role: true)
        employee.save
      end

      employee.roles << Role.find_by(name: Role::ROLE_MANAGER) if evaluator.with_manager_role

      if evaluator.with_admin_role
        employee.roles << Role.find_by(name: Role::ROLE_ADMIN)
        employee.create_onboarding!(state: "completed")
      end

      create(:address, addressable: employee) if evaluator.with_address

      employee.reload
    end
  end
end

# == Schema Information
#
# Table name: employees
#
#  id              :bigint           not null, primary key
#  birthday        :date
#  citizenship     :string(2)
#  country_of_work :string(2)
#  identity_number :string
#  marital_status  :integer
#  name            :string           not null
#  passport_number :string
#  phone_number    :string
#  position        :string
#  religion        :integer
#  start_date      :date
#  status          :integer          default("inactive")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint
#  manager_id      :bigint
#  public_id       :string(19)       not null
#
# Indexes
#
#  index_employees_on_account_id  (account_id)
#  index_employees_on_manager_id  (manager_id)
#  index_employees_on_public_id   (public_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (manager_id => employees.id)
#
