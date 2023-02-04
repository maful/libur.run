# frozen_string_literal: true

class ClaimType < ApplicationRecord
  include ClaimType::Filterable
  include PublicIdGenerator

  self.public_id_prefix = "cty_"

  attribute :year, default: -> { Date.current.year }

  validates :name, presence: true, uniqueness: { scope: :year }
  validates :name, length: { maximum: 50, too_long: "%{count} characters is the maximum allowed" }
  validates :description, length: { maximum: 100, too_long: "%{count} characters is the maximum allowed" }

  # overridden
  def to_param
    public_id
  end
end

# == Schema Information
#
# Table name: claim_types
#
#  id          :bigint           not null, primary key
#  description :string(100)
#  name        :string(50)       not null
#  status      :boolean          default(TRUE)
#  year        :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  public_id   :string(19)       not null
#
# Indexes
#
#  index_claim_types_on_public_id      (public_id) UNIQUE
#  index_claim_types_on_year_and_name  (year,name) UNIQUE
#
