# frozen_string_literal: true

class TeamLeavesPolicy < ApplicationPolicy
  def index?
    user.is_manager? || user.is_admin?
  end

  def show?
    user.is_manager? || user.is_admin?
  end

  def edit?
    user.is_manager?
  end

  def update?
    user.is_manager?
  end
end
