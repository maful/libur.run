# frozen_string_literal: true

class InvitationController < ApplicationController
  before_action :set_company
  before_action :decode_token, only: :edit
  before_action :set_account, only: :edit

  def edit
    if @account.valid_invitation?
      render(:accept)
    else
      render(:expired_token)
    end
  end

  def update
    @account = Account.find_by(invitation_token: params[:token])
    @account.assign_attributes(account_params)

    respond_to do |format|
      if @account.save(context: :account_accept_invitation)
        # accept invitation
        @account.accept_invitation!
        # activate employee
        @account.employee.active!

        format.turbo_stream
      else
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            ActionView::RecordIdentifier.dom_id(@account, "accept_form"),
            partial: "invitation/form",
          ), status: :unprocessable_entity)
        end
      end
    end
  end

  private

  def set_company
    @company = Company.first
  end

  def account_params
    params.require(:account).permit(:password, :password_confirmation)
  end

  def decode_token
    @signed_token = ActiveRecord::Base.signed_id_verifier.verified(params[:token])
    unless @signed_token
      render(:expired_token)
    end
  end

  def set_account
    @account = Account.find_by(invitation_token: @signed_token)
    unless @account
      render(:expired_token)
    end
  end
end
