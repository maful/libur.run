# frozen_string_literal: true

class Dashboard::ClaimsController < DashboardBaseController
  before_action -> { authorize(:claims) }
  before_action :set_claim_group, only: [:show, :cancel]
  before_action :populate_claim_types, only: [:new, :create]

  def index
    @query = current_user.claim_groups
      .recent
      .ransack(params[:query])

    @filtering_values = filtering_values
    @total_amount_condition = if @query.conditions.present?
      @query.conditions.find { |c| c.attributes.map(&:name).first == "total_amount" }
    end

    @pagy, @claim_groups = pagy(@query.result)
  end

  def show
    @claim_group = @claim_group.decorate
    @claims = @claim_group.claims
      .includes(:claim_type)
      .with_attached_receipt
      .decorate
  end

  def new
    @claim_group = ClaimGroup.new
  end

  def create
    @claim_group = current_user.claim_groups.build(claim_group_params)
    respond_to do |format|
      if @claim_group.save
        @message = "Thanks for submitting your claim. We've received it and it's now being reviewed."
        format.html { redirect_to(leaves_path, notice: @message) }
        format.turbo_stream
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@claim_group, "form"),
            partial: "dashboard/claims/form",
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  def validate_claim
    claim = Claim.new(claim_params)
    if claim.valid?
      render(json: { ok: true })
    else
      render(json: claim.errors.to_hash, status: :unprocessable_entity)
    end
  end

  def cancel
    @claim_group.cancel!
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_claim_group
    @claim_group = ClaimGroup.find_by!(public_id: params[:public_id])
  end

  def claim_group_params
    params.require(:claim_group).permit(
      :name,
      claims_attributes: [:claim_type_id, :note, :issue_date, :amount, :employee_id, :receipt],
    )
  end

  def claim_params
    params.require(:claim).permit(
      :note, :issue_date, :claim_type_id, :amount, :employee_id, :receipt
    )
  end

  def populate_claim_types
    @claim_types = ClaimType.select(:id, :name)
  end

  def filtering_values
    return {} if params[:query].blank?

    permitted = params.require(:query).permit(
      :name_i_cont,
      by_status: [],
      c: [:p, a: [], v: []],
    )

    {}.tap do |h|
      # name
      h[:name] = permitted[:name_i_cont].presence

      # statuses
      h[:statuses] = if permitted[:by_status].present?
        permitted[:by_status].map(&:humanize)
      end

      # total amount
      h[:total_amount] = if permitted[:c].present?
        total_amount_condition = permitted[:c].find { |x| x[:a].first == "total_amount" }
        if total_amount_condition.present?
          predicate = Ransack::Translate.predicate(total_amount_condition[:p])
          value = total_amount_condition[:v].first
          amount = Money.from_amount(value.to_f).format(no_cents_if_whole: true)
          "#{predicate.humanize} #{amount}" if value.present?
        end
      end
    end
  end
end
