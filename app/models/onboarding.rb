# frozen_string_literal: true

class Onboarding < ApplicationRecord
  belongs_to :employee, optional: true

  enum :state, [:pending, :in_progress, :completed], default: :pending
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
