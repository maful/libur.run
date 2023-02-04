# frozen_string_literal: true

class Assignment < ApplicationRecord
  belongs_to :employee
  belongs_to :role
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
