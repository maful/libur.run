# frozen_string_literal: true

class Employee < ApplicationRecord
  include Employee::Filterable
  include PublicIdGenerator
  include Religion
  include MaritalStatus
  include ClearCacheCollection

  MAX_AVATAR_SIZE = 1.megabyte

  self.public_id_prefix = "emp_"

  enum :religion, RELIGION_LIST, scopes: false, suffix: true
  enum :marital_status, MARITAL_STATUS_LIST, scopes: false, suffix: true
  enum :status, [:active, :inactive, :archived], default: :inactive

  has_markdown :about
  has_one_attached :avatar do |attachable|
    attachable.variant(:thumb, resize_to_limit: [90, 90])
  end

  belongs_to :account, optional: true, dependent: :destroy
  has_one :address, as: :addressable
  has_one :onboarding
  has_many :assignments, dependent: :destroy
  has_many :roles, through: :assignments
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"
  belongs_to :manager, class_name: "Employee", optional: true
  has_many :leaves
  has_many :managed_leaves, class_name: "Leave", foreign_key: "manager_id"
  has_many :leave_balances, -> { where(year: Date.current.year) }
  has_many :claim_groups

  accepts_nested_attributes_for :address, update_only: true
  accepts_nested_attributes_for :account, update_only: true
  accepts_nested_attributes_for :assignments,
    allow_destroy: true,
    reject_if: proc { |attributes| attributes["role_id"] == "0" }
  # TODO: Save the roles to redis and update every change

  validates :name, presence: true
  validates :birthday, presence: true, on: :employee_setup
  validates :identity_number, presence: true, on: :employee_setup
  validates :religion, presence: true, on: :employee_setup
  validates :marital_status, presence: true, on: :employee_setup
  validates :citizenship, presence: true, on: :employee_setup
  validates :start_date, presence: true, on: :employee_setup
  validates :avatar, blob: { content_type: ["image/png", "image/jpeg"], size_range: 1..(MAX_AVATAR_SIZE) }

  after_create :initiate_leave_balances
  after_create_commit :assign_default_role

  # overridden
  def to_param
    public_id
  end

  # define method for each role
  Role::ORIGINAL_ROLES.each do |role|
    define_method("is_#{role}?") do
      role?(role)
    end
  end

  def onboarding_completed?
    # If the user is not an admin, don't have to do onboarding
    # assume it is completed
    return true unless is_admin?

    onboarding.state.to_sym == :completed
  end

  class << self
    def filter_statuses
      account_statuses = Account.statuses.slice(:unverified)
      Employee.statuses.merge(account_statuses)
    end

    def ransackable_attributes(auth_object = nil)
      ["position"]
    end

    def ransackable_associations(auth_object = nil)
      super & ["account"]
    end

    def ransackable_scopes(auth_object = nil)
      [:by_status, :by_roles]
    end

    def ransackable_scopes_skip_sanitize_args
      [:by_roles]
    end
  end

  private

  def initiate_leave_balances
    balances = []
    LeaveType.where(status: true, year: Date.current.year).find_each do |type|
      balances.push({ leave_type: type, entitled_balance: type.days_per_year, remaining_balance: type.days_per_year })
    end
    leave_balances.create(balances)
  end

  def role?(role)
    roles.any? { |r| r.name.underscore.to_sym == role.to_sym }
  end

  def assign_default_role
    assignments.create!(role: Role.find_by(name: Role::ROLE_USER))
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
