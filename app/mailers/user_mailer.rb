# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def invite
    @employee = Employee.find(params[:employee_id])
    @account = @employee.account
    @company = Company.first
    @signed_token = ActiveRecord::Base.signed_id_verifier.generate(@account.invitation_token)

    mail(to: email_address_with_name(@account.email, @employee.name), subject: 'You have been invited!')
  end
end
