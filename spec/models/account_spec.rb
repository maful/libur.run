# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Account) do
  describe "associations" do
    it { should have_one(:employee).dependent(:destroy) }
  end

  describe "database" do
    it { should have_db_column(:email).of_type(:citext).with_options(null: false) }
    it { should have_db_column(:invitation_token).of_type(:string).with_options(null: true) }
    it { should have_db_index(:invitation_token).unique }
    it { should have_db_column(:invitation_created_at).of_type(:datetime).with_options(null: true) }
    it { should have_db_column(:invitation_sent_at).of_type(:datetime).with_options(null: true) }
    it { should have_db_column(:invitation_accepted_at).of_type(:datetime).with_options(null: true) }
    it { should have_db_index(:email).unique }
    it { should have_db_column(:password_hash).of_type(:string).with_options(null: true) }
    it { should have_db_column(:status).of_type(:integer).with_options(null: false, default: "unverified") }
  end

  describe "validations" do
    subject { build(:account) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should define_enum_for(:status).with_values(unverified: 1, verified: 2, closed: 3) }
    it { should validate_presence_of(:password).on(:account_accept_invitation) }
    it { should validate_presence_of(:password_confirmation).on(:account_accept_invitation) }
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id                     :bigint           not null, primary key
#  email                  :citext           not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  password_hash          :string
#  status                 :integer          default("unverified"), not null
#
# Indexes
#
#  index_accounts_on_email             (email) UNIQUE WHERE (status = ANY (ARRAY[1, 2]))
#  index_accounts_on_invitation_token  (invitation_token) UNIQUE
#
