# frozen_string_literal: true

class Settings::NotificationsPolicy < ApplicationPolicy
  def show?
    user.is_user?
  end
end
