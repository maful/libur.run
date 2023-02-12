# frozen_string_literal: true

class UsersPolicy < ApplicationPolicy
  def index?
    user.is_admin?
  end

  def new?
    user.is_admin?
  end

  def create?
    user.is_admin?
  end

  def show?
    user.is_admin?
  end

  def edit?
    user.is_admin?
  end

  def update?
    user.is_admin?
  end

  def resend_invitation?
    user.is_admin?
  end

  def update_status?
    user.is_admin?
  end
end
