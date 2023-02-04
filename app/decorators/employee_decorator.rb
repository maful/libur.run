# frozen_string_literal: true

class EmployeeDecorator < ApplicationDecorator
  delegate_all

  def roles_name
    object.roles.map(&:name)
  end

  def name_with_email
    "#{object.name} (#{object.account.email})"
  end

  def total_age
    (Date.current.year - object.birthday.year)
  end

  def birthday_date
    object.birthday.to_fs(:common_date)
  end

  def format_phone_number
    object.phone_number.present? ? h.phone_to(object.phone_number) : "-"
  end

  def status_badge
    case object.status.to_sym
    when :active
      :success
    when :inactive
      :error
    when :archived
      :warning
    else
      :default
    end
  end

  def total_experience
    h.distance_of_time_in_words_to_now(object.start_date) if object.start_date?
  end

  def joined_at
    object.start_date.to_fs(:common_date) if object.start_date?
  end

  def country_citizenshp
    return nil if object.citizenship.blank?

    country = ISO3166::Country[object.citizenship]
    country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
  end

  def country_work_name
    return nil if object.country_of_work.blank?

    country = ISO3166::Country[object.country_of_work]
    country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
  end
end
