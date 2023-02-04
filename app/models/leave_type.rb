# frozen_string_literal: true

class LeaveType < ApplicationRecord
  include LeaveType::Filterable
  include PublicIdGenerator

  attribute :year, default: -> { Date.current.year }

  self.public_id_prefix = "lty_"

  validates :name, presence: true
  validates :days_per_year, presence: true, numericality: { greater_than: 0 }
  validates :year, presence: true

  # overridden
  def to_param
    public_id
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
