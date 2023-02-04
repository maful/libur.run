# frozen_string_literal: true

class LeavesPolicy < ApplicationPolicy
  def index?
    user.is_user? && !user.is_admin?
  end

  def summary?
    user.is_user? && !user.is_admin?
  end

  def show?
    user.is_user? && !user.is_admin?
  end

  def new?
    user.is_user? && !user.is_admin?
  end

  def create?
    user.is_user? && !user.is_admin?
  end

  def cancel?
    user.is_user? && !user.is_admin?
  end
end
