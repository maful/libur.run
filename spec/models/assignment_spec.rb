# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Assignment) do
  describe "associations" do
    it { should belong_to(:employee) }
    it { should belong_to(:role) }
  end

  describe "database" do
    it { should have_db_column(:employee_id) }
    it { should have_db_index(:employee_id) }
    it { should have_db_column(:role_id) }
    it { should have_db_index(:role_id) }
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
