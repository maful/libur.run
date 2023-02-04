# frozen_string_literal: true

module ClaimType::Filterable
  extend ActiveSupport::Concern

  included do
    include Filterable

    scope :recent, -> { order(id: :desc) }
  end
end
