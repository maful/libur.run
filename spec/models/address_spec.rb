# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Address) do
  describe "associations" do
    it { should belong_to(:addressable) }
  end

  describe "validations" do
    subject { build(:address) }

    it { should validate_presence_of(:line_1) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:country_code) }
  end

  describe "database" do
    it { should have_db_column(:public_id).of_type(:string).with_options(null: false, limit: 19) }
    it { should have_db_index(:public_id).unique }
    it { should have_db_column(:line_1).of_type(:string).with_options(null: false) }
    it { should have_db_column(:line_2).of_type(:string).with_options(null: true) }
    it { should have_db_column(:city).of_type(:string).with_options(null: false) }
    it { should have_db_column(:state).of_type(:string).with_options(null: false) }
    it { should have_db_column(:country_code).of_type(:string).with_options(null: false, limit: 2) }
    it { should have_db_column(:zip).of_type(:string).with_options(null: false, limit: 10) }
    it { should have_db_column(:addressable_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:addressable_type).of_type(:string).with_options(null: false) }
    it { should have_db_index([:addressable_type, :addressable_id]).unique }
  end

  describe "instance validations" do
    it "able to use country method" do
      address = build(:address, country_code: "ID")
      expect(address.decorate.country_name).to(eq("Indonesia"))
    end
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  addressable_type :string           not null
#  city             :string           not null
#  country_code     :string(2)        not null
#  line_1           :string           not null
#  line_2           :string
#  state            :string           not null
#  zip              :string(10)       not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  addressable_id   :bigint           not null
#  public_id        :string(19)       not null
#
# Indexes
#
#  index_addresses_on_addressable  (addressable_type,addressable_id) UNIQUE
#  index_addresses_on_public_id    (public_id) UNIQUE
#
