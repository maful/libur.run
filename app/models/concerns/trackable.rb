# frozen_string_literal: true

module Trackable
  extend ActiveSupport::Concern

  included do
    include PublicActivity::Common
  end

  def create_tracking(key, recipient: self, owner: self, params: {}, target_user: false)
    controller = PublicActivity.get_controller
    default_params = controller.public_send(:default_tracked_params)

    if target_user
      current_user = controller.public_send(:current_user)
      recipient = current_user
      owner = current_user
    end

    # create activity based on the active model
    create_activity(
      key:,
      recipient:,
      owner:,
      params: default_params.merge(params)
    )

    # clear cache for the security logs
    SecurityLog.new.clear_cache_collection
  end
end
