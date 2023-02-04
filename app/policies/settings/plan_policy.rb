# frozen_string_literal: true

class Settings::PlanPolicy < ApplicationPolicy
  def show?
    user.is_admin?
  end
end
