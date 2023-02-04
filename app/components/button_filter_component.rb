# frozen_string_literal: true

class ButtonFilterComponent < ViewComponent::Base
  attr_reader :text, :type, :direction, :size

  def initialize(label:, value: nil, size: :medium)
    @label = label
    @value = value
    @direction = :left
    @size = size
  end

  def before_render
    if @value.present?
      @value = @value.join(", ") if @value.is_a?(Array)
      @text = "#{@label}: #{@value}"
      @type = :filter_active
    else
      @text = @label
      @type = :filter
    end
  end

  def render?
    content.present?
  end
end
