# frozen_string_literal: true

require "rails_helper"

describe "Installation" do
  it "navigation", :skip_admin do
    visit installation_index_path
    expect(page).to(have_selector("span#installation_title", text: "Introduction"))
    expect(page).to(have_current_path(installation_index_path))
  end

  it "app has been configured" do
    visit installation_index_path
    expect(page).to(have_selector("h1", text: "Sign in to your account"))
    expect(page).to(have_current_path(RodauthApp.rodauth.login_path))
  end

  it "introduction step", :skip_admin do
    visit installation_index_path
    expect(page).to(have_current_path(installation_index_path))
    expect(page).to(have_selector("span#installation_title", text: "Introduction"))
    expect(page).to(have_selector("div#installation_body"))
    within("div#installation_stepper") do
      expect(page).to(have_selector("div.stepper > div:nth-child(1).stepper__item--current"))
    end
    expect(page).to(have_button("Next"))
  end

  it "license step", :skip_admin do
    visit installation_index_path
    find("form").click_button("Next")
    expect(page).to(have_selector("span#installation_title", text: "License"))
    expect(page).to(have_selector("div#installation_body"))
    within("div#installation_stepper") do
      expect(page).to(have_selector("div.stepper > div:nth-child(1).stepper__item--complete"))
      expect(page).to(have_selector("div.stepper > div:nth-child(2).stepper__item--current"))
    end
    expect(page).to(have_button("Next", disabled: true))
    check("license[agree]")
    expect(page).to(have_button("Next"))
  end

  it "license step - back button", :skip_admin do
    visit installation_index_path
    find("form").click_button("Next")
    expect(page).to(have_selector("span#installation_title", text: "License"))
    find("div#installation_actions").click_link("Back")
    expect(page).to(have_current_path(installation_index_path))
  end

  it "personal information step - valid inputs", :skip_admin, sidekiq: :inline do
    visit installation_index_path
    # introduction
    find("form").click_button("Next")
    # license
    check("license[agree]")
    click_button("Next")

    expect(page).to(have_selector("span#installation_title", text: "Personal Information"))
    expect(page).to(have_selector("div#installation_body"))
    within("div#installation_stepper") do
      expect(page).to(have_selector("div.stepper > div:nth-child(1).stepper__item--complete"))
      expect(page).to(have_selector("div.stepper > div:nth-child(2).stepper__item--complete"))
      expect(page).to(have_selector("div.stepper > div:nth-child(3).stepper__item--current"))
    end

    within("form") do
      fill_in("employee[name]", with: Faker::Name.name)
      fill_in("employee[account_attributes][email]", with: Faker::Internet.unique.email(domain: "example"))
      fill_in("employee[account_attributes][password]", with: Faker::Internet.password(min_length: 8))
      attach_file("employee[avatar]", file_fixture("avatar.png").to_s)
    end
    click_button("Save and Continue")
    expect(page).to(have_selector("span#installation_title", text: "Company Details"))
    expect(Employee.count).to(eq(1))
    expect(Employee.first).to(be_is_admin)
    expect(Employee.first.avatar).to(be_attached)
  end

  it "personal information step - invalid inputs", :skip_admin do
    visit installation_index_path
    # introduction
    find("form").click_button("Next")
    # license
    check("license[agree]")
    click_button("Next")

    click_button("Save and Continue")
    within("form") do
      expect(page).to(have_selector("p.input-group__error-message", text: "Name can't be blank"))
      expect(page).to(have_selector("p.input-group__error-message", text: "Email can't be blank"))
    end
    expect(Employee.count).to(eq(0))
  end

  it "company details step - valid inputs", :skip_admin, sidekiq: :inline do
    visit installation_index_path

    create(:employee)
    # delete company for testing
    Company.first&.destroy

    # introduction
    find("form").click_button("Next")
    # license
    check("license[agree]")
    click_button("Next")
    # personal information
    click_button("Save and Continue")

    expect(page).to(have_selector("span#installation_title", text: "Company Details"))
    expect(page).to(have_selector("div#installation_body"))
    within("div#installation_stepper") do
      expect(page).to(have_selector("div.stepper > div:nth-child(1).stepper__item--complete"))
      expect(page).to(have_selector("div.stepper > div:nth-child(2).stepper__item--complete"))
      expect(page).to(have_selector("div.stepper > div:nth-child(3).stepper__item--complete"))
      expect(page).to(have_selector("div.stepper > div:nth-child(4).stepper__item--current"))
    end

    within("form") do
      fill_in("company[name]", with: Faker::Company.name)
      fill_in("company[email]", with: Faker::Internet.unique.email(domain: "example"))
      attach_file("company[logo]", file_fixture("avatar.png").to_s)
    end
    click_button("Save and Continue")
    expect(page).to(have_selector("span#installation_title", text: "Welcome!"))
    expect(Company.count).to(eq(1))
  end

  it "company details step - invalid inputs", :skip_admin, sidekiq: :inline do
    visit installation_index_path

    create(:employee)
    # delete company for testing
    Company.first&.destroy

    # introduction
    find("form").click_button("Next")
    # license
    check("license[agree]")
    click_button("Next")
    # personal information
    click_button("Save and Continue")

    expect(page).to(have_selector("span#installation_title", text: "Company Details"))
    click_button("Save and Continue")
    within("form") do
      expect(page).to(have_selector("p.input-group__error-message", text: "Name can't be blank"))
      expect(page).to(have_selector("p.input-group__error-message", text: "Email can't be blank"))
    end
    expect(Company.count).to(eq(0))
  end
end
