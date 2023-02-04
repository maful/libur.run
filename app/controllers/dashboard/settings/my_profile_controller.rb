# frozen_string_literal: true

class Dashboard::Settings::MyProfileController < DashboardBaseController
  before_action -> { authorize([:settings, :my_profile]) }

  def show
    @user = Employee.includes(assignments: :role).find(current_user.id).decorate
    @account = @user.account.decorate
    @address = @user.address.try(:decorate)
  end
end
