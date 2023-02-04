# frozen_string_literal: true

class DashboardBaseController < ApplicationController
  include Pagy::Backend
  include Pundit::Authorization

  layout "dashboard"

  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :not_found_page
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Pagy::OverflowError, with: :not_found_page

  helper_method :current_user
  helper_method :current_company

  private

  def pagy_get_vars(collection, vars)
    vars[:count] ||= cache_count(collection)
    vars[:page] ||= params[vars[:page_param] || Pagy::DEFAULT[:page_param]]
    vars
  end

  def cache_count(collection)
    cache_key = "pagy-#{collection.cache_key}"
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      collection.count(:all)
    end
  end

  # redirect to login page if not authenticated
  def authenticate
    rodauth.require_account
  end

  def current_user
    current_account.employee if rodauth.logged_in?
  end

  def current_company
    Company.first if current_user.present?
  end

  def not_found_page
    render("errors/not_found", status: :not_found)
  end

  def user_not_authorized
    render("errors/forbidden", status: :forbidden)
  end
end
