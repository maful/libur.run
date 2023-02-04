# frozen_string_literal: true

module LeaveBalance::Filterable
  extend ActiveSupport::Concern

  included do
    include Filterable

    scope :recent, -> { order(id: :desc) }
  end
end
