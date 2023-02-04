# frozen_string_literal: true

class CalendarPolicy < ApplicationPolicy
  def index?
    user.is_user?
  end
end
