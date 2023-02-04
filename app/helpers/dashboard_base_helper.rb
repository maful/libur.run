# frozen_string_literal: true

module DashboardBaseHelper
  include Pagy::Frontend

  def active_page?(controller_name)
    current_page?(controller: controller_name)
  rescue
    false
  end
end
