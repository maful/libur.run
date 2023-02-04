# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    email { Faker::Internet.unique.email(domain: "example") }
    password { Faker::Internet.password(min_length: 8) }
    status { "verified" }

    trait :unverified do
      status { "unverified" }
    end

    trait :closed do
      status { "closed" }
    end

    transient do
      with_employee { false }
    end

    after :create do |account, evaluator|
      if evaluator.with_employee
        # create employee
        employee = create(:employee, account:)
        account.reload
      end
    end
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
