# frozen_string_literal: true

class NavbarLinkComponent < ViewComponent::Base
  def initialize(title:, path:, controller_name: nil, show_dot: false, only_for: [])
    @title = title
    @path = path
    @controller_name = controller_name
    @show_dot = show_dot
    @only_for = only_for
  end

  def before_render
    @active = helpers.active_page?(@controller_name || @path.delete_prefix("/"))
  end

  def render?
    @only_for.all? do |role|
      method = "is_#{role}?".to_sym
      return false unless helpers.current_user.respond_to?(method)

      helpers.current_user.public_send(method)
    end
  end
end
