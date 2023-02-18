# frozen_string_literal: true

class Leave < ApplicationRecord
  include Leave::Filterable
  include Leave::ApprovalStatusMachine
  include PublicIdGenerator
  include ClearCacheCollection

  attribute :year, default: -> { Date.current.year }

  self.public_id_prefix = "lea_"

  belongs_to :employee
  belongs_to :manager, class_name: "Employee", optional: true
  belongs_to :leave_type

  has_one_attached :document

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :year, presence: true
  validates :note, length: { maximum: 100, too_long: "%{count} characters is the maximum allowed" }
  validates :comment, length: { maximum: 100, too_long: "%{count} characters is the maximum allowed" }
  validates :half_day_time, inclusion: { in: ["AM", "PM"], message: "%{value} is not a valid time" }, allow_blank: true
  validate :ensure_leave_balance_sufficient, on: :leave_approval, if: :approved?

  before_validation :calculate_days_of_leave, on: :create
  before_validation :ensure_leave_balance_sufficient, on: :create

  after_validation :set_half_day

  before_create :set_manager

  # overridden
  def to_param
    public_id
  end

  class << self
    def ransackable_attributes(auth_object = nil)
      super & ["public_id", "approval_status", "number_of_days", "leave_type_id"]
    end

    def ransackable_associations(auth_object = nil)
      if auth_object == :manager
        super & ["employee"]
      end
    end
  end

  private

  attr_accessor :leave_balance

  def set_half_day
    self.half_day = true if half_day_time?
  end

  def set_manager
    self.manager_id = employee.manager_id
  end

  # Calculate the number of days of leave, not including weekends.
  def calculate_days_of_leave
    # if the date is same
    days = if end_date.eql?(start_date)
      # if half day is checked, set to 0.5
      # otherwise is 1
      half_day_time? ? 0.5 : 1
    else
      ((start_date)..(end_date)).select { |d| (1..5).include?(d.wday) }.size
    end
    self.number_of_days = days
  end

  def ensure_leave_balance_sufficient
    return if start_date.blank? || end_date.blank? || leave_type_id.blank?

    self.leave_balance = LeaveBalance.where(employee:, leave_type_id:, year: Date.current.year).first
    unless leave_balance
      errors.add(:base, "Unable to find the current balance, please try again.") && return
    end

    message = "Sorry, you do not have enough leave balance for this request. Please check your balance and try again."
    if approved?
      message = "This leave cannot be approved as it exceeds the leave balance."
    end

    if number_of_days > leave_balance.remaining_balance
      errors.add(:base, message) && return
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
