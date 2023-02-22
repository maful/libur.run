# frozen_string_literal: true

require "rails_helper"

describe "Change password" do
  let(:password) { Faker::Internet.password(min_length: 8) }
  let(:account) { create(:account, password:) }
  let(:employee) { create(:employee, with_manager_assigned: true, account:) }

  before do
    login(employee.account)
  end

  it "navigation" do
    visit home_path

    # click the dropdown menu
    user_menu = find("nav[aria-label='Main'] button#user-menu-button")
    user_menu.click

    # verify the dropdown menu
    dropdown_menu = user_menu.sibling("div:not(.hidden)")
    expect(dropdown_menu).to(be_visible)
    expect(dropdown_menu).to(have_content("Settings"))
    expect(dropdown_menu).to(have_content("Sign out"))

    # click the Settings link
    click_link("Settings", href: settings_root_path)
    expect(page).to(have_current_path(settings_my_profile_path))
    expect(page).to(have_selector("div.tabs > div[role='tablist'] > div[role='presentation']", count: 4))
    click_link("Password", href: settings_password_path)
    expect(page).to(have_selector("h3", text: "Password"))
  end

  it "valid inputs" do
    visit settings_password_path

    new_password = Faker::Internet.password(min_length: 8)
    within("form.simple_form") do
      fill_in("account[current_password]", with: password)
      fill_in("account[new_password]", with: new_password)
      fill_in("account[new_password_confirmation]", with: new_password)
      click_button("Update password")
    end
    expect(page).to(have_content("Password was successfully updated."))
  end

  it "invalid inputs" do
    visit settings_password_path

    within("form.simple_form") do
      click_button("Update password")
      expect(page).to(have_selector("p.input-group__error-message", text: "Current password can't be blank"))
      expect(page).to(have_selector("p.input-group__error-message", text: "New password can't be blank"))
    end
  end

  it "invalid current password" do
    visit settings_password_path

    new_password = Faker::Internet.password(min_length: 8)
    within("form.simple_form") do
      fill_in("account[current_password]", with: "randompassword")
      fill_in("account[new_password]", with: new_password)
      fill_in("account[new_password_confirmation]", with: new_password)
      click_button("Update password")
      expect(page).to(have_selector("p.input-group__error-message", text: "Current password doesn't match"))
    end
  end

  it "new password is too short" do
    visit settings_password_path

    new_password = Faker::Internet.password(min_length: 3)
    within("form.simple_form") do
      fill_in("account[current_password]", with: password)
      fill_in("account[new_password]", with: new_password)
      fill_in("account[new_password_confirmation]", with: new_password)
      click_button("Update password")
      expect(page).to(have_selector("p.input-group__error-message", text: "New password is too short"))
    end
  end

  it "new password doesn't match" do
    visit settings_password_path

    within("form.simple_form") do
      fill_in("account[current_password]", with: password)
      fill_in("account[new_password]", with: Faker::Internet.password(min_length: 8))
      fill_in("account[new_password_confirmation]", with: "randompassword")
      click_button("Update password")
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: "New password confirmation doesn't match New password",
      ))
    end
  end
end
