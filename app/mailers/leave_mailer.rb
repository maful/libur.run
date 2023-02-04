# frozen_string_literal: true

class LeaveMailer < ApplicationMailer
  before_action :set_leave
  before_action :set_company

  def pending_leave_request
    mail(
      to: email_address_with_name(@manager.account.email, @manager.name),
      subject: "Leave Request ID: #{@leave.public_id} from #{@requestor.name}",
    )
  end

  def canceled_leave_request
    mail(
      to: email_address_with_name(@manager.account.email, @manager.name),
      subject: "Leave Request ID: #{@leave.public_id} Cancelled",
    )
  end

  def approved_leave_request
    mail(
      to: email_address_with_name(@requestor.account.email, @requestor.name),
      subject: "Leave Request ID: #{@leave.public_id} Approved",
    )
  end

  def rejected_leave_request
    mail(
      to: email_address_with_name(@requestor.account.email, @requestor.name),
      subject: "Leave Request ID: #{@leave.public_id} Rejected",
    )
  end

  private

  def set_leave
    @leave = Leave.includes(manager: :account, employee: :account).find(params[:leave_id]).decorate
    @requestor = @leave.employee
    @manager = @leave.manager
  end

  def set_company
    @company = Company.first
  end
end
