# frozen_string_literal: true

class Modal::FooterComponent < ViewComponent::Base
  def render?
    content.present?
  end
end
