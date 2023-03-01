# frozen_string_literal: true

class AccountDecorator < ApplicationDecorator
  delegate_all

  def status_badge
    case object.status.to_sym
    when :verified
      :success
    when :unverified
      :warning
    else
      :error
    end
  end
end
