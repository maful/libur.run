# frozen_string_literal: true

class Dashboard::HomeController < DashboardBaseController
  before_action -> { authorize(:home) }

  def index
  end
end
