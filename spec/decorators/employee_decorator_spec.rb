# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EmployeeDecorator) do
  include ActionView::Helpers::DateHelper

  let(:decorator) { EmployeeDecorator.new(object) }
  let(:account) { create(:account) }
  let(:object) do
    create(:employee, citizenship: "ID", country_of_work: "ID", birthday: Date.new(2000, 12, 31), account:)
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

  it "can get status badge" do
    expect(decorator.status_badge).to(eq("success".to_sym))
  end

  it "can get total experience" do
    expect(decorator.total_experience).to(eq(distance_of_time_in_words_to_now(object.start_date)))
  end

  it "can get joined date" do
    expect(decorator.joined_at).to(eq(object.start_date.to_fs(:common_date)))
  end

  it "can get country of work name" do
    expect(decorator.country_work_name).to(eq("Indonesia"))
  end
end
