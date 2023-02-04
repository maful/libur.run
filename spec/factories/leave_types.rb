# frozen_string_literal: true

FactoryBot.define do
  factory :leave_type do
    name do
      ["Annual Leave", "Sick Leave", "Family Leave", "Bereavement Leave", "Personal Leave", "Study Leave",
       "Jury Duty Leave",].sample
    end
    status { true }
    days_per_year { 14 }

    trait :inactive do
      status { false }
    end
  end
end

# == Schema Information
#
# Table name: leave_types
#
#  id            :bigint           not null, primary key
#  days_per_year :integer          not null
#  name          :string           not null
#  status        :boolean          default(TRUE)
#  year          :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  public_id     :string(19)       not null
#
# Indexes
#
#  index_leave_types_on_year  (year)
#
