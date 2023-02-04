# frozen_string_literal: true

class LeaveDecorator < ApplicationDecorator
  delegate_all

  def format_dates
    if object.start_date.eql?(object.end_date)
      object.start_date.to_fs(:common_date)
    elsif same_month_and_year?
      "#{object.start_date.strftime("%d")} - #{object.end_date.to_fs(:common_date)}"
    elsif same_year?
      "#{object.start_date.strftime("%d %B")} - #{object.end_date.to_fs(:common_date)}"
    else
      "#{object.start_date.to_fs(:common_date)} - #{object.end_date.to_fs(:common_date)}"
    end
  end

  def description
    "#{object.leave_type.name} (#{days_range})"
  end

  def truncate_note
    object.note? ? h.truncate(object.note, length: 40) : "-"
  end

  def approval_status_badge
    case object.approval_status.to_sym
    when :approved
      :success
    when :denied
      :error
    when :canceled
      :warning
    when :taken
      :"outline-indigo"
    else
      :default
    end
  end

  def approval_status_title
    Leave.human_attribute_name("approval_status.#{object.approval_status}")
  end

  def total_days
    if object.number_of_days.to_f == 0.5
      "-0.5 day"
    else
      "-#{h.pluralize(object.number_of_days.to_i, "day")}"
    end
  end

  private

  def same_month_and_year?
    object.start_date.month == object.end_date.month && same_year?
  end

  def same_year?
    object.start_date.year == object.end_date.year
  end

  def days_range
    if object.number_of_days.to_f == 0.5
      "half-day #{object.half_day_time}"
    else
      h.pluralize(object.number_of_days.to_i, "day")
    end
  end
end
