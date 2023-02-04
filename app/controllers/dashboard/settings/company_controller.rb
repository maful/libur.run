# frozen_string_literal: true

class Dashboard::Settings::CompanyController < DashboardBaseController
  before_action -> { authorize([:settings, :company]) }
  before_action :set_company
  before_action :populate_employees

  def show
  end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.turbo_stream
      else
        format.html { render(:show, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@company, "form"),
            partial: "dashboard/settings/company/form",
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  private

  def set_company
    @company = current_company
  end

  def populate_employees
    @employees = Employee.includes(:account).where(status: :active).decorate
  end

  def company_params
    params.require(:company).permit(
      :name, :logo, :email, :phone, :finance_approver_id
    )
  end
end
