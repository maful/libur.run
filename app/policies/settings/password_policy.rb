# frozen_string_literal: true

class Settings::PasswordPolicy < ApplicationPolicy
  def show?
    user.is_user?
  end

  def update?
    user.is_user?
  end
end
