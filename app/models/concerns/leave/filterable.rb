# frozen_string_literal: true

module Leave::Filterable
  extend ActiveSupport::Concern

  included do
    include Filterable

    scope :recent, -> { order(id: :desc) }
    scope :for_calendar, ->(start_date, end_date) {
      start_date = Date.parse(start_date) if start_date.is_a?(String)
      end_date = Date.parse(end_date) if end_date.is_a?(String)

      arel = arel_table
      between_start_date = arel[:start_date].between(start_date..end_date)
      between_end_date = arel[:end_date].between(start_date..end_date)

      where(approval_status: Leave::STATE_APPROVED).where(between_start_date.or(between_end_date))
    }
  end
end
