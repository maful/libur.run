# frozen_string_literal: true

require "rails_helper"

describe "Forgot password" do
  let(:employee) { create(:employee) }

  before do
    employee
  end

  it "navigation" do
    visit RodauthApp.rodauth.login_path
    click_link("Forgot your password?")
    expect(page).to(have_selector("h1", text: "Reset your password"))
    expect(page).to(have_current_path(RodauthApp.rodauth.reset_password_request_path))
  end

  it "valid email" do
    visit RodauthApp.rodauth.reset_password_request_path
    within("form") do
      fill_in("login", with: employee.account.email)
      click_button("Reset your password")
    end
    expect(employee.account.password_reset_key.key).to(be_present)
    expect(page).to(have_current_path(RodauthApp.rodauth.login_path))
    expect(page).to(have_selector(
      "div.alert.alert--info",
      text: "An email has been sent to you with a link to reset the password for your account",
    ))
  end

  it "invalid email" do
    visit RodauthApp.rodauth.reset_password_request_path
    within("form") do
      fill_in("login", with: Faker::Internet.unique.email(domain: "examplecom"))
      click_button("Reset your password")
      expect(page).to(have_selector("span.form__error", text: "Email address doesn't exist"))
    end
  end

  it "reset link has been sent" do
    visit RodauthApp.rodauth.reset_password_request_path
    within("form") do
      fill_in("login", with: employee.account.email)
      click_button("Reset your password")
    end
    expect(employee.account.password_reset_key.key).to(be_present)

    visit RodauthApp.rodauth.reset_password_request_path
    within("form") do
      fill_in("login", with: employee.account.email)
      click_button("Reset your password")
    end
    expect(page).to(have_selector(
      "div.alert.alert--error",
      text: "An email has recently been sent to you with a link to reset your password",
    ))
  end
end
