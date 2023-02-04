class ClaimMailer < ApplicationMailer
  before_action :set_claim_group
  before_action :set_company

  def pending_claim_request
    @approver = @company.finance_approver
    if @approver.present?
      mail(
        to: email_address_with_name(@approver.account.email, @approver.name),
        subject: "New Claim Request from #{@requestor.name}",
      )
    end
  end

  def rejected_claim_request
    mail(
      to: email_address_with_name(@requestor.account.email, @requestor.name),
      subject: "Claim Request ID: #{@claim_group.public_id} Rejected",
    )
  end

  def approved_claim_request
    mail(
      to: email_address_with_name(@requestor.account.email, @requestor.name),
      subject: "Claim Request ID: #{@claim_group.public_id} Approved",
    )
  end

  private

  def set_claim_group
    @claim_group = ClaimGroup.includes(employee: :account).find(params[:id]).decorate
    @requestor = @claim_group.employee
  end

  def set_company
    @company = Company.first
  end
end
