# frozen_string_literal: true

class Role < ApplicationRecord
  include PublicIdGenerator
  include Role::Roles
  include Role::Filterable

  self.public_id_prefix = "rle_"

  has_many :assignments
  has_many :employees, through: :assignments

  validates :name, presence: true, uniqueness: true
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
