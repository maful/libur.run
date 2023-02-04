# frozen_string_literal: true

class OnboardingPolicy < ApplicationPolicy
  def index?
    user.is_admin?
  end

  def personal_info?
    user.is_admin?
  end

  def company_info?
    user.is_admin?
  end

  def confirmation?
    user.is_admin?
  end

  def verified?
    user.is_admin?
  end

  def states?
    user.is_admin?
  end

  def cities?
    user.is_admin?
  end
end
