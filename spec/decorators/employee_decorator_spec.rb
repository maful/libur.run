# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EmployeeDecorator) do
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::UrlHelper

  let(:decorator) { described_class.new(object) }
  let(:account) { create(:account) }
  let(:birthday) { Date.new(2000, 12, 31) }
  let(:object) do
    create(:employee, citizenship: "ID", country_of_work: "ID", birthday:, account:)
  end

  it "can get roles name" do
    expect(decorator.roles_name).to(match_array(["user"]))
  end

  it "can get name with email" do
    expect(decorator.name_with_email).to(eq("#{object.name} (#{object.account.email})"))
  end

  it "can get total age" do
    current_year = Date.current.year
    age = current_year - object.birthday.year
    expect(decorator.total_age).to(eq(age))
  end

  it "can get birthday date" do
    expect(decorator.birthday_date).to(eq("31 December 2000"))
  end

  it "can get citizenshp" do
    expect(decorator.country_citizenshp).to(eq("Indonesia"))
  end

  context "can get empty citizenshp" do
    let(:object) { create(:employee, citizenship: nil, account:) }

    it { expect(decorator.country_citizenshp).to(be_blank) }
  end

  it "can get total experience" do
    expect(decorator.total_experience).to(eq(distance_of_time_in_words_to_now(object.start_date)))
  end

  context "can get empty total experience" do
    let(:object) { create(:employee, start_date: nil, account:) }

    it { expect(decorator.total_experience).to(be_blank) }
  end

  it "can get joined date" do
    expect(decorator.joined_at).to(eq(object.start_date.to_fs(:common_date)))
  end

  context "can get empty joined date" do
    let(:object) { create(:employee, start_date: nil, account:) }

    it { expect(decorator.joined_at).to(be_blank) }
  end

  it "can get country of work name" do
    expect(decorator.country_work_name).to(eq("Indonesia"))
  end

  context "can get country of work" do
    let(:object) { create(:employee, country_of_work: nil, account:) }

    it { expect(decorator.country_work_name).to(be_blank) }
  end

  it "can get formatted phone number" do
    expect(decorator.format_phone_number).to(eq(phone_to(object.phone_number)))
  end

  context "can get empty phone number" do
    let(:object) { create(:employee, phone_number: nil, account:) }

    it { expect(decorator.format_phone_number).to(eq("-")) }
  end

  context "can get active badge" do
    it { expect(decorator.status_badge).to(eq("success".to_sym)) }
  end

  context "can get inactive badge" do
    let(:object) { create(:employee, :inactive, account:) }

    it { expect(decorator.status_badge).to(eq("error".to_sym)) }
  end

  context "can get archived badge" do
    let(:object) { create(:employee, :archived, account:) }

    it { expect(decorator.status_badge).to(eq("warning".to_sym)) }
  end
end
