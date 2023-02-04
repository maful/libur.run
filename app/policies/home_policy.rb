# frozen_string_literal: true

class HomePolicy < ApplicationPolicy
  def index?
    user.is_user?
  end
end
