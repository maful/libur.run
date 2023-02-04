# frozen_string_literal: true

class EmptyStateComponent < ViewComponent::Base
  renders_one :description
  renders_one :actions

  def initialize(title:)
    @title = title
  end
end
