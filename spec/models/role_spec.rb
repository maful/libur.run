# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Role) do
  describe "associations" do
    it { should have_many(:assignments) }
    it { should have_many(:employees).through(:assignments) }
  end

  describe "validations" do
    subject { build(:role) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "database" do
    it { should have_db_column(:public_id).of_type(:string).with_options(null: false, limit: 19) }
    it { should have_db_index(:public_id).unique }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_index(:name).unique }
  end
end

# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  public_id  :string(19)       not null
#
# Indexes
#
#  index_roles_on_name       (name) UNIQUE
#  index_roles_on_public_id  (public_id) UNIQUE
#
