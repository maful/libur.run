# frozen_string_literal: true

module Leave::ApprovalStatusMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    enum approval_status: {
      pending: 0,
      approved: 1,
      denied: 2,
      canceled: 3,
      taken: 4,
    }

    aasm column: :approval_status, enum: true, logger: Rails.logger do
      state :pending, initial: true
      state :approved
      state :denied
      state :canceled
      state :taken

      event :accepted, before: :set_approval_date do
        transitions from: :pending, to: :approved
      end

      event :rejected, before: :set_approval_date do
        transitions from: :pending, to: :denied
      end

      event :cancel, before: :set_approval_date, after_commit: :notify_approver do
        transitions from: :pending, to: :canceled
      end
    end

    # callbacks
    after_create_commit :notify_approver, if: proc { pending? }
    after_update_commit :notify_requestor, if: proc { approved? || denied? }

    def set_approval_date
      self.approval_date = Time.current
    end

    def notify_requestor
      if approved?
        reduce_leave_balance
        LeaveMailer.with(leave_id: id).approved_leave_request.deliver_later
      end

      if denied?
        LeaveMailer.with(leave_id: id).rejected_leave_request.deliver_later
      end
    end

    def notify_approver
      if pending?
        LeaveMailer.with(leave_id: id).pending_leave_request.deliver_later
      end

      if canceled?
        LeaveMailer.with(leave_id: id).canceled_leave_request.deliver_later
      end
    end

    def reduce_leave_balance
      leave_balance.remaining_balance -= number_of_days
      leave_balance.save!
    end
  end
end
