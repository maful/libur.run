# frozen_string_literal: true

class Settings::CompanyPolicy < ApplicationPolicy
  def show?
    user.is_admin?
  end

  def update?
    user.is_admin?
  end
end
