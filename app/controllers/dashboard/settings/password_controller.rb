# frozen_string_literal: true

class Dashboard::Settings::PasswordController < DashboardBaseController
  before_action -> { authorize([:settings, :password]) }
  before_action :set_account

  def show
  end

  def update
    @account.assign_attributes(account_params)
    respond_to do |format|
      if @account.save(context: :account_change_password)
        format.turbo_stream
      else
        format.html { render(:show, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@account, "form"),
            partial: "dashboard/settings/password/form",
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  private

  def set_account
    @account = current_account
  end

  def account_params
    params.require(:account).permit(
      :current_password, :new_password, :new_password_confirmation
    )
  end
end
