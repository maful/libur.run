# frozen_string_literal: true

class Dashboard::UsersController < DashboardBaseController
  before_action -> { authorize(:users) }

  before_action :set_user, only: [:edit, :update, :resend_invitation]
  before_action :populate_roles, except: [:index, :show, :resend_invitation]
  before_action :populate_form_create, only: [:new, :create]
  before_action :populate_form_update, only: [:edit, :update]

  def index
    @query = Employee
      .includes(:account, assignments: :role)
      .recent
      .ransack(params[:query])

    @roles = Role.select(:id, :name).where.not(name: Role::ROLE_USER).recent
    @filtering_values = filtering_values
    @position_condition = if @query.conditions.present?
      @query.conditions.find { |c| c.attributes.map(&:name).first == "position" }
    end

    @pagy, @users = pagy(@query.result)
  end

  def show
    @user = Employee.includes(assignments: :role).find_by!(public_id: params[:public_id]).decorate
    @account = @user.account.decorate
    @address = @user.address.try(:decorate)
  end

  def new
    @user = Employee.new
    @user.assignments.build
  end

  def edit
  end

  def create
    @user = Employee.new(user_params)

    respond_to do |format|
      if @user.save(context: :employee_setup)
        @user.account.send_invitation
        format.html { redirect_to(users_path, notice: "User was successfully created.", status: :see_other) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@user, "form"),
            partial: "dashboard/users/form",
            locals: { user: @user, form_path: @form_path, form_method: @form_method },
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(update_params)
        format.html { redirect_to(users_path, notice: "User was successfully updated.", status: :see_other) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@user, "form"),
            partial: "dashboard/users/form",
            locals: { user: @user, form_path: @form_path, form_method: @form_method },
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  def resend_invitation
    @account = @user.account
    unless @account.invitation_accepted?
      @account.send_invitation
      respond_to do |format|
        format.turbo_stream
      end
    end
  end

  private

  def set_user
    @user = Employee.find_by!(public_id: params[:public_id])
  end

  def user_params
    params.require(:user).permit(
      :name, :manager_id, :birthday, :citizenship, :identity_number, :about, :marital_status,
      :passport_number, :phone_number, :religion, :position, :start_date, :country_of_work,
      account_attributes: [:email],
      address_attributes: [:line_1, :line_2, :city, :state, :country_code, :zip],
      assignments_attributes: [:id, :role_id, :_destroy]
    )
  end

  def update_params
    new_update_params = user_params
    new_update_params[:assignments_attributes].each do |idx, elm|
      if elm.key?(:id) && elm.key?(:role_id) && elm[:role_id].to_i == 0
        new_update_params[:assignments_attributes][idx]["_destroy"] = true
      end
    end if new_update_params[:assignments_attributes].present?
    new_update_params
  end

  def populate_form_create
    @form_path = users_path
    @form_method = :post
    @managers = Employee.includes(:account)
      .only_active
      .only_manager_role
      .recent
      .decorate
  end

  def populate_form_update
    @form_path = user_path(@user)
    @form_method = :patch
    @managers = Employee.includes(:account)
      .only_active
      .only_manager_role
      .without_me(@user)
      .recent
      .decorate
  end

  def populate_roles
    @roles = Role.select(:id, :name).where.not(name: Role::ROLE_ADMIN).recent
  end

  def filtering_values
    return {} if params[:query].blank?

    permitted = params.require(:query).permit(
      :account_email_eq,
      by_status: [],
      by_roles: [],
      c: [:p, a: [], v: []],
    )

    {}.tap do |h|
      # email
      h[:email] = permitted[:account_email_eq].presence

      # statuses
      h[:statuses] = if permitted[:by_status].present?
        permitted[:by_status].map(&:humanize)
      end

      # roles
      h[:roles] = if permitted[:by_roles].present?
        @roles.select { |r| permitted[:by_roles].include?(r.id.to_s) }.map(&:name).map(&:humanize)
      end

      # position
      h[:position] = if permitted[:c].present?
        position_condition = permitted[:c].find { |x| x[:a].first == "position" }
        if position_condition.present?
          predicate = Ransack::Translate.predicate(position_condition[:p])
          value = position_condition[:v].first
          "#{predicate.humanize} #{value}" if value.present?
        end
      end
    end
  end
end
