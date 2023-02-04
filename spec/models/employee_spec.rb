# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Employee) do
  describe "associations" do
    it { should have_one_attached(:avatar) }
    it { should have_one(:address) }
    it { should have_one(:onboarding) }
    it { should have_many(:assignments).dependent(:destroy) }
    it { should have_many(:roles) }
    it { should have_many(:subordinates).class_name("Employee").with_foreign_key("manager_id") }
    it { should have_many(:leaves) }
    it { should have_many(:managed_leaves).class_name("Leave").with_foreign_key("manager_id") }
    it { should have_many(:leave_balances) }
    it { should have_many(:claim_groups) }
    it { should belong_to(:manager).class_name("Employee").optional }
    it { should belong_to(:account).optional }
  end

  describe "validations" do
    subject { build(:employee) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:birthday).on(:employee_setup) }
    it { should validate_presence_of(:identity_number).on(:employee_setup) }
    it { should validate_presence_of(:religion).on(:employee_setup) }
    it { should validate_presence_of(:marital_status).on(:employee_setup) }
    it { should validate_presence_of(:citizenship).on(:employee_setup) }
    it { should validate_presence_of(:start_date).on(:employee_setup) }
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
