# frozen_string_literal: true

FactoryBot.define do
  factory :assignment do
    association :employee
    association :role
  end
end

# == Schema Information
#
# Table name: assignments
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  employee_id :bigint
#  role_id     :bigint
#
# Indexes
#
#  index_assignments_on_employee_id  (employee_id)
#  index_assignments_on_role_id      (role_id)
#
