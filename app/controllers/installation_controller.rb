# frozen_string_literal: true

class InstallationController < ApplicationController
  before_action :verify_installation, only: :index
  before_action :set_onboarding, except: [:index, :company]
  before_action :set_employee, only: [:personal, :company]
  before_action :set_company, only: [:company, :complete]

  def index
    @current_step = 1
    @onboarding = Onboarding.exists? ? Onboarding.first : Onboarding.create
  end

  def license
    @current_step = 2
    @onboarding.in_progress!
  end

  def personal
    @current_step = 3
    @onboarding.update(license_params.slice(:subscribe)) if params[:license].present?
  end

  def company
    @current_step = 4
    # save admin account
    attrs = employee_params.dup
    if @employee.persisted? && attrs[:account_attributes][:password].blank?
      attrs[:account_attributes] = attrs[:account_attributes].except(:password)
    end
    @employee.assign_attributes(attrs)
    respond_to do |format|
      if @employee.save(context: :account_installation)
        @employee.roles << Role.find_by(name: Role::ROLE_ADMIN) unless @employee.is_admin?
        @employee.active!
        @employee.account.verified!
        format.turbo_stream
      else
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@employee, "form"),
            partial: "installation/personal_form",
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  def complete
    @current_step = 6
    # save company
    @company.assign_attributes(company_params)
    respond_to do |format|
      if @company.save
        @onboarding.completed!
        format.turbo_stream
      else
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@company, "form"),
            partial: "installation/company_form",
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  private

  def set_onboarding
    @onboarding = Onboarding.first
  end

  def set_employee
    @employee = Employee.exists? ? Employee.first : Employee.new
  end

  def set_company
    @company = Company.exists? ? Company.first : Company.new
  end

  def license_params
    params.require(:license).permit(:agree, :subscribe)
  end

  def employee_params
    params.require(:employee).permit(:name, :avatar, account_attributes: [:email, :password])
  end

  def company_params
    params.require(:company).permit(:name, :email, :logo)
  end

  def verify_installation
    if onboarding_complete? && company_exists?
      redirect_to(rodauth.login_path)
    end
  end
end
