# frozen_string_literal: true

class ClaimsPolicy < ApplicationPolicy
  def index?
    user.is_user?
  end

  def show?
    user.is_user?
  end

  def new?
    user.is_user?
  end

  def create?
    user.is_user?
  end

  def validate_claim?
    user.is_user?
  end

  def cancel?
    user.is_user?
  end
end
