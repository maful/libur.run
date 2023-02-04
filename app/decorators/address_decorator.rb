# frozen_string_literal: true

class AddressDecorator < ApplicationDecorator
  delegate_all

  def country_name
    country = ISO3166::Country[object.country_code]
    country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
  end
end
