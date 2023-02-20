# frozen_string_literal: true

module Employee::Filterable
  extend ActiveSupport::Concern

  included do
    include Filterable

    scope :recent, -> { order(id: :desc) }
    scope :without_me, ->(user) { where.not(id: user) }
    scope :only_manager_role, -> {
      role = Role.find_by(name: Role::ROLE_MANAGER)
      joins(:assignments).where(assignments: { role: role })
    }
    scope :only_active, -> {
      where(status: :active)
    }
    scope :for_birthday, ->(month) {
      where("date_part('month', birthday) = ?", month)
    }
    scope :by_status, ->(*statuses) {
      emp_states = Set.new
      acc_statuses = Set.new
      statuses = [statuses] if statuses.is_a?(String)
      statuses.each do |s|
        if Employee.statuses.key?(s)
          emp_states.add(s)
        elsif Account.statuses.key?(s)
          acc_statuses.add(s)
        end
      end

      query = all
      if emp_states.present?
        query = query.where(status: emp_states)
      end

      if acc_statuses.present?
        query = if emp_states.present?
          query.or(Employee.where(account_id: Account.where(status: acc_statuses)))
        else
          query.where(account_id: Account.where(status: acc_statuses))
        end
      end

      query
    }
    scope :by_roles, ->(*role_ids) {
      where(id: Assignment.select(:employee_id).where(role_id: role_ids)) if role_ids.present?
    }
  end
end
