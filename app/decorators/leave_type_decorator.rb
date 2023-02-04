# frozen_string_literal: true

class LeaveTypeDecorator < ApplicationDecorator
  delegate_all

  def status_title
    object.status ? "Active" : "Inactive"
  end

  def status_badge
    object.status ? :success : :error
  end
end
