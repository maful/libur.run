# frozen_string_literal: true

module ClaimGroup::Filterable
  extend ActiveSupport::Concern

  included do
    include Filterable

    scope :recent, -> { order(id: :desc) }
    scope :by_status, ->(*statuses) {
      where(approval_status: statuses.map(&:to_sym))
    }
  end
end
