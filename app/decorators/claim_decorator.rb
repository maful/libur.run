# frozen_string_literal: true

class ClaimDecorator < ApplicationDecorator
  delegate_all

  def issued_at
    object.issue_date.to_fs(:common_date)
  end
end
