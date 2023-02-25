# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Leave) do
  describe "associations" do
    it { should belong_to(:employee) }
    it { should belong_to(:manager).class_name("Employee").optional }
    it { should belong_to(:leave_type) }
    it { should have_one_attached(:document) }
  end

  describe "validations" do
    subject { build(:leave) }

    # TODO: Fix crash test
    # it { should validate_presence_of(:start_date) }
    # it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:year) }
    it { should validate_length_of(:note).is_at_most(100).with_message("100 characters is the maximum allowed") }
    it { should validate_length_of(:comment).is_at_most(100).with_message("100 characters is the maximum allowed") }
    it {
      expect(subject).to(validate_inclusion_of(:half_day_time)
        .in_array(["AM", "PM"])
        .with_message("Shoulda::Matchers::ExampleClass is not a valid time"))
    }
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
