# frozen_string_literal: true

class ClaimGroupDecorator < ApplicationDecorator
  delegate_all

  def submission_at
    object.submission_date.to_fs(:common_date_time)
  end

  def status_badge
    case object.approval_status.to_sym
    when :completed
      "outline-indigo".to_sym
    when :approved
      :success
    when :denied
      :error
    when :canceled
      :warning
    else
      :default
    end
  end
end
