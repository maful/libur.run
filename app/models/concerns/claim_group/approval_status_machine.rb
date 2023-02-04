# frozen_string_literal: true

module ClaimGroup::ApprovalStatusMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    enum approval_status: { pending: 0, approved: 1, denied: 2, canceled: 3, completed: 4 }

    aasm column: :approval_status, enum: true, logger: Rails.logger do
      state :pending, initial: true
      state :approved
      state :denied
      state :canceled
      state :completed

      event :accepted, before: :set_approval_date do
        transitions from: :pending, to: :approved
      end

      event :rejected, before: :set_approval_date do
        transitions from: :pending, to: :denied
      end

      event :cancel, before: :set_approval_date do
        transitions from: :pending, to: :canceled
      end
    end

    after_create_commit :notify_approver, if: proc { pending? }
    after_update_commit :notify_requestor, if: proc { approved? || denied? }

    def notify_approver
      ClaimMailer.with(id:).pending_claim_request.deliver_later
    end

    def notify_requestor
      if denied?
        ClaimMailer.with(id:).rejected_claim_request.deliver_later
      end

      if approved?
        ClaimMailer.with(id:).approved_claim_request.deliver_later
      end
    end

    def set_approval_date
      self.approval_date = Time.current
    end
  end
end
