# frozen_string_literal: true

class AccountDecorator < ApplicationDecorator
  delegate_all

  def status_badge
    case object.status.to_sym
    when :verified
      :success
    when :closed
      :error
    when :unverified
      :warning
    else
      :default
    end
  end
end
