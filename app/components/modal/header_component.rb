# frozen_string_literal: true

class Modal::HeaderComponent < ViewComponent::Base
  renders_one :supporting_text

  attr_reader :title, :icon

  def initialize(title:, icon:)
    @title = title
    @icon = icon
  end

  def render?
    title.present?
  end
end
