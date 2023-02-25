# frozen_string_literal: true

require "rails_helper"

describe "Submit claim" do
  let(:employee) { create(:employee) }
  let(:ct_travel) { create(:claim_type, name: "Travel expenses") }
  let(:ct_meal) { create(:claim_type, name: "Meal expenses") }

  around do |example|
    travel_to(Time.zone.local(2023, 2)) { example.run }
  end

  before do
    login(employee.account)
    ct_travel
    ct_meal
  end

  it "valid inputs", sidekiq: :inline do
    visit claims_path
    expect(page).to(have_selector("h1", text: "Claims Management"))
    expect(page).to(have_current_path(claims_path))
    expect(page).to(have_selector("div.empty-state h1", text: "No Claim History"))

    first(:link, "Submit claim", href: new_claim_path).click
    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    test_form = [
      { claim_type: ct_travel.name, amount: 30, issue_date: "2023-01-31", note: "Taxi" },
      { claim_type: ct_meal.name, amount: 7, issue_date: "2023-01-31", note: "Breakfast" },
      { claim_type: ct_meal.name, amount: 10, issue_date: "2023-01-31", note: "Lunch" },
      {
        claim_type: ct_meal.name,
        amount: 15,
        issue_date: "2023-01-31",
        note: "Dinner",
        receipt: file_fixture("doctor-note.jpeg").to_s,
      },
    ]
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Submit a Claim"))
      within("form#form_claim_group") do
        fill_in("claim_group[name]", with: "Business Meeting")
        within("div[data-claims--form-target='targetForm']") do
          test_form.each do |tf|
            within("div[data-claims--form-target='newClaim']") do
              expect(page).to(have_select("Claim type", with_options: [ct_travel.name, ct_meal.name]))
              find("select[name^='claim_group[claims_attributes]'][name$='[claim_type_id]']").select(tf[:claim_type])
              find("input[name^='claim_group[claims_attributes]'][name$='[amount]']").set(tf[:amount])
              issue_date_input = find("input[name^='claim_group[claims_attributes]'][name$='[issue_date]']")
              issue_date_input_rect = issue_date_input.native.rect
              issue_date_input.set(tf[:issue_date])
              # click outside the element to close the datepicker
              page.driver.browser.action.move_to(
                issue_date_input.native,
                issue_date_input_rect.width + 10,
                0,
              ).click.perform
              find("textarea[name^='claim_group[claims_attributes]'][name$='[note]']").set(tf[:note])
              if tf[:receipt].present?
                find("input[type='file'][name$='[receipt]']").attach_file(tf[:receipt])
              end
            end
            click_button("Add claim")
          end
        end
      end
      find("div.modal__footer").click_button("Submit")
    end
    expect(page).to(have_content("Thanks for submitting your claim."))
    expect(find("turbo-frame#claim-groups-list")).to(have_selector("table tbody tr", count: 1))
    expect(Claim.count).to(eq(4))
    within(:xpath, ".//turbo-frame[@id='claim-groups-list']/table/tbody/tr[1]") do
      claim_group_decorator = ClaimGroupDecorator.new(employee.claim_groups.last)
      expect(page).to(have_xpath(".//td[1]", text: claim_group_decorator.name))
      expect(page).to(have_xpath(".//td[2]", text: "$62"))
      expect(page).to(have_xpath(".//td[3]", text: "Pending"))
      expect(page).to(have_xpath(".//td[4]", text: claim_group_decorator.submission_at))
    end
  end

  it "invalid inputs - name" do
    visit claims_path
    first(:link, "Submit claim", href: new_claim_path).click
    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Submit a Claim"))
      find("form#form_claim_group").fill_in("claim_group[name]", with: "")
      find("div.modal__footer").click_button("Submit")
      expect(page).to(have_selector("p.input-group__error-message", text: "Name can't be blank"))
    end
    expect(ClaimGroup.count).to(eq(0))
  end

  it "invalid inputs - claim item" do
    visit claims_path
    first(:link, "Submit claim", href: new_claim_path).click
    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Submit a Claim"))
      within("form#form_claim_group div[data-claims--form-target='targetForm']") do
        click_button("Add claim")
        expect(page).to(have_selector("p.input-group__error-message", text: "Claim type must exist"))
        expect(page).to(have_selector("p.input-group__error-message", text: "Amount is not a number"))
        expect(page).to(have_selector("p.input-group__error-message", text: "Issue date can't be blank"))
      end
    end
    expect(ClaimGroup.count).to(eq(0))
  end

  it "invalid receipt - content type" do
    visit claims_path
    first(:link, "Submit claim", href: new_claim_path).click
    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      within("div[data-claims--form-target='newClaim']") do
        find("input[type='file'][name$='[receipt]']").attach_file(file_fixture("logo-dark.svg").to_s)
      end
      click_button("Add claim")
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: I18n.t("errors.messages.content_type_invalid"),
      ))
    end
  end

  it "invalid receipt - file size" do
    visit claims_path
    first(:link, "Submit claim", href: new_claim_path).click
    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      receipt_file = file_fixture("big-image.jpg")
      within("div[data-claims--form-target='newClaim']") do
        find("input[type='file'][name$='[receipt]']").attach_file(receipt_file.to_s)
      end
      click_button("Add claim")
      file_size = ActiveSupport::NumberHelper.number_to_human_size(receipt_file.size)
      expect(page).to(have_selector(
        "p.input-group__error-message",
        text: I18n.t("errors.messages.file_size_out_of_range", file_size:),
      ))
    end
  end

  it "is able to delete claim item" do
    visit claims_path
    first(:link, "Submit claim", href: new_claim_path).click
    expect(page).to(have_selector("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']"))
    test_form = [
      { claim_type: ct_travel.name, amount: 30, issue_date: "2023-01-31", note: "Taxi" },
      { claim_type: ct_meal.name, amount: 7, issue_date: "2023-01-31", note: "Breakfast" },
    ]
    within("turbo-frame#turbo_modal > div[data-controller='modal'][role='dialog']") do
      expect(page).to(have_selector("h1", text: "Submit a Claim"))
      within("form#form_claim_group") do
        within("div[data-claims--form-target='targetForm']") do
          test_form.each do |tf|
            within("div[data-claims--form-target='newClaim']") do
              find("select[name^='claim_group[claims_attributes]'][name$='[claim_type_id]']").select(tf[:claim_type])
              find("input[name^='claim_group[claims_attributes]'][name$='[amount]']").set(tf[:amount])
              issue_date_input = find("input[name^='claim_group[claims_attributes]'][name$='[issue_date]']")
              issue_date_input_rect = issue_date_input.native.rect
              issue_date_input.set(tf[:issue_date])
              # click outside the element to close the datepicker
              page.driver.browser.action.move_to(
                issue_date_input.native,
                issue_date_input_rect.width + 5,
                0,
              ).click.perform
              find("textarea[name^='claim_group[claims_attributes]'][name$='[note]']").set(tf[:note])
            end
            click_button("Add claim")
          end
        end

        expect(page).to(have_selector("table.table tbody tr", count: test_form.length))
        find("table.table tbody tr:nth-child(1) > td:nth-child(1)").click_button
        expect(page).to(have_selector("table.table tbody tr", count: test_form.length - 1))
      end
    end
  end
end
