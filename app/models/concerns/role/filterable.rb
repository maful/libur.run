# frozen_string_literal: true

module Role::Filterable
  extend ActiveSupport::Concern

  included do
    include Filterable

    scope :recent, -> { order(id: :desc) }
  end
end
