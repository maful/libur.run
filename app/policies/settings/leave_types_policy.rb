# frozen_string_literal: true

class Settings::LeaveTypesPolicy < ApplicationPolicy
  def index?
    user.is_admin?
  end

  def new?
    user.is_admin?
  end

  def create?
    user.is_admin?
  end

  def edit?
    user.is_admin?
  end

  def update?
    user.is_admin?
  end
end
