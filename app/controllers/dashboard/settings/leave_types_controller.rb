# frozen_string_literal: true

class Dashboard::Settings::LeaveTypesController < DashboardBaseController
  layout false
  before_action -> { authorize([:settings, :leave_types]) }
  before_action :set_leave_type, only: [:edit, :update]
  before_action :form_create, only: [:new, :create]
  before_action :form_update, only: [:edit, :update]

  def index
    @leave_types = LeaveType.recent.try(:decorate)
  end

  def new
    @leave_type = LeaveType.new
  end

  def edit
  end

  def create
    @leave_type = LeaveType.new(leave_type_params)

    if @leave_type.save
      respond_to do |format|
        @message = "Leave Type was successfully created."
        format.html { redirect_to(settings_leave_types_path, notice: @message) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    if @leave_type.update(leave_type_params)
      respond_to do |format|
        @message = "Leave Type was successfully updated."
        format.html { redirect_to(settings_leave_types_path, notice: @message) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def set_leave_type
    @leave_type = LeaveType.find_by!(public_id: params[:public_id])
  end

  def leave_type_params
    params.require(:leave_type).permit(:name, :days_per_year, :status)
  end

  def form_create
    @form_path = settings_leave_types_path
    @form_method = :post
  end

  def form_update
    @form_path = settings_leave_type_path(@leave_type)
    @form_method = :patch
  end
end
