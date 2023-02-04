# frozen_string_literal: true

class Address < ApplicationRecord
  include PublicIdGenerator

  self.public_id_prefix = "adr_"

  belongs_to :addressable, polymorphic: true

  validates :line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :country_code, presence: true
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
