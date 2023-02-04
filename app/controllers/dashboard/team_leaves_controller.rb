# frozen_string_literal: true

class Dashboard::TeamLeavesController < DashboardBaseController
  before_action -> { authorize(:team_leaves) }
  before_action :set_leave, except: :index

  def index
    @query = find_all.includes(:leave_type, employee: :account)
      .recent
      .ransack(params[:query], auth_object: :manager)

    @leave_types = LeaveType.recent
    @approval_statuses = find_approval_statuses
    @filtering_values = filtering_values
    @days_condition = if @query.conditions.present?
      @query.conditions.find { |c| c.attributes.map(&:name).first == "number_of_days" }
    end

    @pagy, @leaves = pagy(@query.result)
  end

  def show
  end

  def edit
    @type = params[:type]
  end

  def update
    @type = params[:type]
    @type == "reject" ? @leave.rejected : @leave.accepted
    @leave.assign_attributes(leave_params)

    respond_to do |format|
      if @leave.save(context: :leave_approval)
        @message = I18n.t("dashboard.team_leaves.form.#{@type}.notification")
        format.html { redirect_to(team_leaves_path, notice: @message) }
        format.turbo_stream
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@leave, "form_approval"),
            partial: "dashboard/team_leaves/form",
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  private

  def find_all
    if current_user.is_admin?
      Leave
    else
      current_user.managed_leaves.not_canceled
    end
  end

  def find_approval_statuses
    if current_user.is_admin?
      Leave.approval_statuses.without(:taken)
    else
      Leave.approval_statuses.without(:canceled, :taken)
    end
  end

  def set_leave
    @leave = if current_user.is_admin?
      Leave.find_by!(public_id: params[:public_id]).decorate
    else
      current_user.managed_leaves.find_by!(public_id: params[:public_id]).decorate
    end
  end

  def leave_params
    params.require(:leave).permit(:comment)
  end

  def filtering_values
    return {} if params[:query].blank?

    permitted = params.require(:query).permit(
      :employee_account_email_eq,
      :number_of_days_eq,
      :leave_type_id_eq,
      approval_status_in: [],
      c: [:p, a: [], v: []],
    )

    {}.tap do |h|
      # email
      h[:email] = permitted[:employee_account_email_eq].presence

      # approval statuses
      statuses = permitted[:approval_status_in]
      h[:status] = if statuses.present?
        statuses.map { |v| Leave.approval_statuses.invert[v.to_i].humanize }
      end

      # leave type
      h[:leave_type] = if permitted[:leave_type_id_eq].present?
        @leave_types.select { |v| v.id == permitted[:leave_type_id_eq].try(:to_i) }
          .try(:first)
          .try(:name)
      end

      # total days
      h[:days] = if permitted[:c].present?
        days_condition = permitted[:c].find { |x| x[:a].first == "number_of_days" }
        if days_condition.present?
          predicate = Ransack::Translate.predicate(days_condition[:p])
          value = days_condition[:v].first
          "#{predicate.humanize} #{value}" if value.present?
        end
      end
    end
  end
end
