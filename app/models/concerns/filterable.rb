# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filtering(filtering_params)
      results = where(nil)
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end
  end
end
