# frozen_string_literal: true

class Dashboard::Settings::ClaimTypesController < DashboardBaseController
  layout false
  before_action -> { authorize([:settings, :claim_types]) }
  before_action :set_claim_type, only: [:edit, :update]
  before_action :form_create, only: [:new, :create]
  before_action :form_update, only: [:edit, :update]

  def index
    @claim_types = ClaimType.recent.try(:decorate)
  end

  def new
    @claim_type = ClaimType.new
  end

  def edit
  end

  def create
    @claim_type = ClaimType.new(claim_type_params)

    if @claim_type.save
      respond_to do |format|
        @message = "Claim Type was successfully created."
        format.html { redirect_to(settings_claim_types_path, notice: @message) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    if @claim_type.update(claim_type_params)
      respond_to do |format|
        @message = "Claim Type was successfully updated."
        format.html { redirect_to(settings_claim_types_path, notice: @message) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def set_claim_type
    @claim_type = ClaimType.find_by!(public_id: params[:public_id])
  end

  def claim_type_params
    params.require(:claim_type).permit(:name, :description, :status)
  end

  def form_create
    @form_path = settings_claim_types_path
    @form_method = :post
  end

  def form_update
    @form_path = settings_claim_type_path(@claim_type)
    @form_method = :patch
  end
end
