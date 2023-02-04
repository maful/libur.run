# frozen_string_literal: true

class AlertComponent < ViewComponent::Base
  attr_reader :options, :dismissable

  DEFAULT_STATUS = :info
  STATUS_CLASSES = {
    DEFAULT_STATUS => "alert--info",
    :error => "alert--error",
    :warning => "alert--warning",
    :success => "alert--success",
  }.freeze

  def initialize(status: DEFAULT_STATUS, dismissable: false, **options)
    @options = options
    @dismissable = dismissable
    @options[:class] = class_names(
      "alert",
      STATUS_CLASSES[status.to_sym],
      @options[:classes],
    )
  end

  def before_render
    @options["data-controller"] = "alert" if dismissable
  end

  def render?
    content.present?
  end
end
