# frozen_string_literal: true

module MaritalStatus
  extend ActiveModel::Translation

  MARITAL_STATUS_LIST = {
    single: 0,
    married: 1,
    divorced: 2,
    widowed: 3,
    not_to_say: 4,
  }.freeze

  def marital_status_name
    return nil if marital_status.blank?

    MaritalStatus.human_attribute_name("status.#{marital_status}")
  end
end
