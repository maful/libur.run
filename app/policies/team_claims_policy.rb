# frozen_string_literal: true

class TeamClaimsPolicy < ApplicationPolicy
  attr_reader :company

  def initialize(user, record)
    super
    @company = Company.first
  end

  def index?
    finance_approver? || user.is_admin?
  end

  def show?
    finance_approver? || user.is_admin?
  end

  def edit?
    finance_approver?
  end

  def update?
    finance_approver?
  end

  private

  def finance_approver?
    user.id == company.finance_approver_id
  end
end
