# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Company) do
  describe "associations" do
    it { should have_one_attached(:logo) }
    it { should have_one(:address) }
    it { should belong_to(:finance_approver).class_name("Employee").optional }
  end

  describe "validations" do
    subject { build(:company) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe "database" do
    it { should have_db_column(:public_id).of_type(:string).with_options(null: false, limit: 19) }
    it { should have_db_index(:public_id).unique }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:website).of_type(:string).with_options(null: true) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_index(:email).unique }
    it { should have_db_column(:phone).of_type(:string) }
  end
end

# == Schema Information
#
# Table name: companies
#
#  id                  :bigint           not null, primary key
#  email               :string           not null
#  name                :string           not null
#  phone               :string
#  website             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  finance_approver_id :bigint
#  public_id           :string(19)       not null
#
# Indexes
#
#  index_companies_on_email                (email) UNIQUE
#  index_companies_on_finance_approver_id  (finance_approver_id)
#  index_companies_on_public_id            (public_id) UNIQUE
#
