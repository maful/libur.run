# frozen_string_literal: true

class Dashboard::Settings::NotificationsController < DashboardBaseController
  before_action -> { authorize([:settings, :notifications]) }

  def show
  end
end
