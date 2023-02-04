# frozen_string_literal: true

class ButtonDropdownComponent < ViewComponent::Base
  renders_many :links, "LinkComponent"

  attr_reader :text, :button_class, :menu_class, :icon, :icon_position_class

  DEFAULT_TYPE = :button
  BUTTON_TYPES = {
    DEFAULT_TYPE => "btn btn--primary",
    :navbar => "navbar__item",
    :filter => "btn btn--tertiary-gray btn--small btn--dashed btn--circle",
    :filter_active => "btn btn--tertiary-color btn--small btn--solid btn--circle",
  }

  DEFAULT_DIRECTION = :right
  MENU_DIRECTIONS = {
    DEFAULT_DIRECTION => "button-dropdown__menu--right-direction",
    :left => "button-dropdown__menu--left-direction",
  }

  DEFAULT_SIZE = :medium
  MENU_SIZE_CLASSES = {
    DEFAULT_SIZE => nil,
    :large => "button-dropdown__menu--large-size",
  }

  DEFAULT_ICON = "chevron-down"
  DEFAULT_ICON_POSITION = :right
  ICON_POSITION_CLASSES = {
    DEFAULT_ICON_POSITION => "button-dropdown__icon--right-position",
    :left => "button-dropdown__icon--left-position",
  }

  def initialize(text: nil, type: DEFAULT_TYPE, direction: DEFAULT_DIRECTION, size: DEFAULT_SIZE, icon: DEFAULT_ICON,
    icon_position: :right)
    @text = text || "Actions"
    @button_class = BUTTON_TYPES[type.to_sym]
    @direction = direction
    @size = size
    @icon = icon
    @icon_position_class = ICON_POSITION_CLASSES[icon_position.to_sym]
  end

  def before_render
    @menu_class = helpers.class_names(
      MENU_DIRECTIONS[@direction.to_sym],
      MENU_SIZE_CLASSES[@size.to_sym],
    )
  end

  def render?
    links? || content.present?
  end

  class LinkComponent < ViewComponent::Base
    attr_reader :name, :href, :options

    def initialize(name:, href:, hide: false, **options)
      @name = name
      @href = href
      @hide = hide
      @options = options
      @options[:class] = class_names(
        "button-dropdown__link",
        @options[:class],
      )
    end

    def render?
      !@hide
    end

    def call
      tag.a(href:, **options) { name }
    end
  end
end
