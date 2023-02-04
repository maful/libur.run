# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if onboarding_complete? && company_exists?
      redirect_to(rodauth.login_path)
    else
      redirect_to(installation_index_path)
    end
  end
end
