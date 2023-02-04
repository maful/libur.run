# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  include Turbo::FramesHelper

  renders_one :header, Modal::HeaderComponent
  renders_one :body, Modal::BodyComponent
  renders_one :footer, Modal::FooterComponent

  attr_reader :size_class

  DEFAULT_SIZE = :medium
  SIZE_CLASSES = {
    DEFAULT_SIZE => nil,
    :large => "modal__container--large-size",
  }

  def initialize(size: DEFAULT_SIZE)
    @size_class = SIZE_CLASSES[size.to_sym]
  end
end
