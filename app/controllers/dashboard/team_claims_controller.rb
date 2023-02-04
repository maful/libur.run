# frozen_string_literal: true

class Dashboard::TeamClaimsController < DashboardBaseController
  before_action -> { authorize(:team_claims) }
  before_action :set_claim_group, only: [:show, :edit, :update]

  def index
    @query = ClaimGroup
      .includes(employee: :account)
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

  def edit
    @type = params[:type]
  end

  def update
    @type = params[:type]
    @type == "reject" ? @claim_group.rejected : @claim_group.accepted
    @claim_group.assign_attributes(claim_group_params.merge(approver_id: current_user.id))

    respond_to do |format|
      if @claim_group.save
        @message = I18n.t("dashboard.team_claims.form.#{@type}.notification")
        format.html { redirect_to(team_claims_path, notice: @message) }
        format.turbo_stream
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@claim_group, "form_approval"),
            partial: "dashboard/team_claims/form",
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  private

  def set_claim_group
    @claim_group = ClaimGroup.find_by!(public_id: params[:public_id])
  end

  def claim_group_params
    params.require(:claim_group).permit(:comment)
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
