# frozen_string_literal: true

class Modal::BodyComponent < ViewComponent::Base
  def render?
    content.present?
  end
end
