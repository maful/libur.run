# frozen_string_literal: true

module Account::Invitable
  extend ActiveSupport::Concern

  VALID_FOR = 3.days

  included do
    extend ActiveModel::Callbacks

    define_model_callbacks :invitation_created, :invitation_accepted
  end

  def send_invitation
    invite!(employee_id: employee.id)
  end

  # Accept an invitation by clearing invitation token and and setting invitation_accepted_at
  def accept_invitation
    self.invitation_accepted_at = Time.now.utc
    self.invitation_token = nil
  end

  # Accept an invitation by clearing invitation token and and setting invitation_accepted_at
  # and run the invitation_accepted callback
  def accept_invitation!
    @accepting_invitation = true
    run_callbacks(:invitation_accepted) do
      accept_invitation
      self.status = :verified
      save
    end.tap do |saved|
      rollback_accepted_invitation unless saved
      @accepting_invitation = false
    end
  end

  def rollback_accepted_invitation
    self.invitation_token = invitation_token_was
    self.invitation_accepted_at = nil
    self.status = :unverified
  end

  # Verifies whether a user has been invited or not
  def invited_to_sign_up?
    accepting_invitation? || (persisted? && invitation_token.present?)
  end

  # Returns true if accept_invitation! was called
  def accepting_invitation?
    @accepting_invitation
  end

  # Verifies whether a user accepted an invitation (false when user is accepting it)
  def invitation_accepted?
    !accepting_invitation? && invitation_accepted_at.present?
  end

  # Reset invitation token and send invitation again
  def invite!(options = {})
    yield self if block_given?

    generate_invitation_token

    run_callbacks(:invitation_created) do
      self.invitation_created_at = Time.now.utc
      self.invitation_sent_at = invitation_created_at

      if save
        deliver_invitation(options)
      end
    end
  end

  def deliver_invitation(options = {})
    employee_id = options.key?(:employee_id) ? options[:employee_id] : employee.id
    UserMailer.with(employee_id:).invite.deliver_later
  end

  # Verify whether a invitation is active or not.
  def valid_invitation?
    invited_to_sign_up? && invitation_period_valid?
  end

  # Checks if the invitation for the user is within the limit time.
  def invitation_period_valid?
    time = invitation_created_at || invitation_sent_at
    VALID_FOR.to_i.zero? || (time && time.utc >= VALID_FOR.ago)
  end

  protected

  def generate_invitation_token
    20.times do
      self.invitation_token = SecureRandom.hex(30)
      return unless self.class.exists?(invitation_token:)
    end

    raise "Failed to generate a unique invitation token after 20 attempts"
  end
end
