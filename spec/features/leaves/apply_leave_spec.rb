# frozen_string_literal: true

require "rails_helper"

describe "Apply leave" do
  let(:leave_type) { create(:leave_type, name: "Annual Leave") }
  let(:leave_type2) { create(:leave_type, name: "Sick Leave", days_per_year: 1) }
  let(:manager) { create(:manager) }
  let(:employee) { create(:employee, manager:) }

  around do |example|
    travel_to(Time.zone.local(2023, 2)) { example.run }
  end

  before do
    leave_type
    leave_type2
    employee
    login(employee.account)
  end

  it "valid inputs" do
    visit leaves_path
    expect(page).to(have_selector("h1", text: "My Leaves"))
    expect(page).to(have_selector("a", text: "Apply leave"))
    expect(page).to(have_current_path(leaves_path))
    expect(page).to(have_selector("div.empty-state h1", text: "No Leave Requests Found"))

    first(:link, "Apply leave", href: new_leave_path).click
    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Apply Leave"))
      within("form#form_leave") do
        find("select#leave_leave_type_id option", text: /#{leave_type.name}/).select_option
        fill_in("leave[start_date]", with: "2023-02-02")
        find("span", text: "to").click # close the datepicker
        fill_in("leave[end_date]", with: "2023-02-03")
        find("span", text: "to").click # close the datepicker
        fill_in("leave[note]", with: "See you later!")
        attach_file(File.expand_path(file_fixture("doctor-note.jpeg"))) do
          find('input[name="leave[document]"]').click
        end
      end
      find("div.modal__footer").click_button("Submit")
    end
    expect(page).to(have_content("Your leave request has been received. You will be notified "\
      "once your manager has reviewed your request."))
    expect(find("turbo-frame#leaves-list")).to(have_selector("table tbody tr", count: 1))
    within(:xpath, ".//turbo-frame[@id='leaves-list']/table/tbody/tr[1]") do
      leave_decorator = LeaveDecorator.new(Leave.last)
      expect(page).to(have_xpath(".//td[1]", text: leave_decorator.format_dates))
      expect(page).to(have_xpath(".//td[2]", text: leave_decorator.description))
      expect(page).to(have_xpath(".//td[3]", text: leave_decorator.note))
      expect(page).to(have_xpath(".//td[4]", text: "Pending"))
    end
  end

  it "invalid inputs" do
    visit leaves_path
    first(:link, "Apply leave", href: new_leave_path).click
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Apply Leave"))
      find("div.modal__footer").click_button("Submit")
      expect(page).to(have_content("Leave type must exist"))
      expect(page).to(have_content("Start date can't be blank"))
      expect(page).to(have_content("End date can't be blank"))
    end
    expect(employee.leaves.count).to(eq(0))
  end

  it "invalid attachment - content type" do
    visit leaves_path
    first(:link, "Apply leave", href: new_leave_path).click
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      attach_file(File.expand_path(file_fixture("logo-dark.svg"))) do
        find('input[name="leave[document]"]').click
      end
      find("div.modal__footer").click_button("Submit")
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: I18n.t("activerecord.errors.messages.content_type"),
      ))
    end
    expect(employee.leaves.count).to(eq(0))
  end

  it "invalid attachment - file size" do
    visit leaves_path
    first(:link, "Apply leave", href: new_leave_path).click
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      attach_file(File.expand_path(file_fixture("big-image.jpg"))) do
        find('input[name="leave[document]"]').click
      end
      find("div.modal__footer").click_button("Submit")
      max_size = ActiveSupport::NumberHelper.number_to_human_size(Leave::MAX_DOCUMENT_SIZE)
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: I18n.t("activerecord.errors.messages.max_size_error", max_size:),
      ))
    end
    expect(employee.leaves.count).to(eq(0))
  end

  it "exceeded leave balance" do
    visit leaves_path
    first(:link, "Apply leave", href: new_leave_path).click
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Apply Leave"))
      within("form#form_leave") do
        find("select#leave_leave_type_id option", text: /#{leave_type2.name}/).select_option
        fill_in("leave[start_date]", with: "2023-02-02")
        find("span", text: "to").click # close the datepicker
        fill_in("leave[end_date]", with: "2023-02-10")
        find("span", text: "to").click # close the datepicker
      end
      find("div.modal__footer").click_button("Submit")
      expect(page).to(have_content("Sorry, you do not have enough leave balance for this "\
        "request. Please check your balance and try again."))
    end
    expect(employee.leaves.count).to(eq(0))
  end

  it "manager has not assigned" do
    employee.update(manager: nil)
    visit leaves_path
    first(:link, "Apply leave", href: new_leave_path).click
    expect(page).to(have_selector("div.alert", text: "Your manager needs to be assigned before"))
  end
end
