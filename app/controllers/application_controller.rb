# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def onboarding_complete?
    Onboarding.exists?(state: :completed)
  end

  def company_exists?
    Company.exists?
  end
end
