# frozen_string_literal: true

class Dashboard::Settings::MeController < DashboardBaseController
  before_action -> { authorize([:settings, :me]) }
  before_action :set_user

  def show
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.turbo_stream
      else
        format.html { render(:show, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@user, "form"),
            partial: "dashboard/settings/me/form",
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :name, :about, :avatar,
      account_attributes: [:email]
    )
  end
end
