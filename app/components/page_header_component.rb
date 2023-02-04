# frozen_string_literal: true

class PageHeaderComponent < ViewComponent::Base
  renders_one :supporting_text
  renders_one :actions

  def initialize(title:, show_breadcrumb: true)
    @title = title
    @show_breadcrumb = show_breadcrumb
  end

  def breadcrumbs
    helpers.breadcrumbs(style: :ul, class: "breadcrumb__list",
      fragment_class: "breadcrumb__item",
      current_class: "breadcrumb__item--current",
      link_class: "breadcrumb__link",
      aria_current: "location")
  end
end
