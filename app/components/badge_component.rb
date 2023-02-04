# frozen_string_literal: true

class BadgeComponent < ViewComponent::Base
  attr_reader :title, :options

  DEFAULT_STATUS = :default
  STATUS_CLASSES = {
    DEFAULT_STATUS => "badge--gray",
    :error => "badge--error",
    :warning => "badge--warning",
    :success => "badge--success",
    :"outline-indigo" => "badge--outline-indigo",
  }.freeze

  DEFAULT_SIZE = :medium
  SIZE_CLASSES = {
    DEFAULT_SIZE => "badge--medium",
    :large => "badge--large",
    :small => "badge--small",
  }

  def initialize(title:, status: DEFAULT_STATUS, size: DEFAULT_SIZE, **options)
    @title = title
    @options = options
    @options[:class] = class_names(
      "badge",
      STATUS_CLASSES[status.to_sym],
      SIZE_CLASSES[size.to_sym],
      @options[:classes],
    )
  end

  def render?
    @title.present?
  end
end
