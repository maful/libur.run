# frozen_string_literal: true

class Dashboard::LeavesController < DashboardBaseController
  before_action -> { authorize(:leaves) }
  before_action :set_leave, only: [:show, :cancel]
  before_action :populate_leave_balances, only: [:new, :create]

  def index
    @query = current_user.leaves
      .includes(:leave_type, :manager)
      .recent
      .ransack(params[:query])

    @leave_types = LeaveType.recent
    @filtering_values = filtering_values
    @days_condition = if @query.conditions.present?
      @query.conditions.find { |c| c.attributes.map(&:name).first == "number_of_days" }
    end

    @pagy, @leaves = pagy(@query.result)
  end

  def summary
    @leave_balances = current_user.leave_balances
      .includes(:leave_type)
      .recent
      .decorate
    leave_type_ids = @leave_balances.map(&:leave_type_id)
    @leaves = current_user.leaves
      .where(leave_type_id: leave_type_ids, approval_status: [:approved, :taken])
      .order(id: :asc)
      .decorate
  end

  def show
  end

  def new
    @leave = Leave.new
  end

  def create
    attrs = leave_params
    attrs[:half_day_time] = nil if attrs[:half_day_time] == "on"

    @leave = current_user.leaves.build(attrs)
    respond_to do |format|
      if @leave.save
        @message = "Your leave request has been received. You will be notified once your manager has reviewed your request."
        format.html { redirect_to(leaves_path, notice: @message) }
        format.turbo_stream
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@leave, "form"),
            partial: "dashboard/leaves/form",
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  def cancel
    @leave.cancel!
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_leave
    @leave = current_user.leaves.find_by!(public_id: params[:public_id]).decorate
  end

  def leave_params
    params.require(:leave).permit(
      :note, :document, :half_day_time, :leave_type_id, :start_date, :end_date
    )
  end

  # get the leave types from the balance in order to get the remaining balance
  def populate_leave_balances
    @leave_balances = current_user.leave_balances.includes(:leave_type).decorate
  end

  def filtering_values
    return {} if params[:query].blank?

    permitted = params.require(:query).permit(
      :leave_type_id_eq,
      approval_status_in: [],
      c: [:p, a: [], v: []],
    )

    {}.tap do |h|
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
