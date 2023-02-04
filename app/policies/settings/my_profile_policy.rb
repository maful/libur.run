# frozen_string_literal: true

class Settings::MyProfilePolicy < ApplicationPolicy
  def show?
    user.is_user?
  end
end
