# frozen_string_literal: true

require "rails_helper"

describe "Filter team claims" do
  let(:manager) { create(:manager) }
  let(:employee) { create(:employee, manager:) }
  let(:ct_travel) { create(:claim_type, name: "Travel expenses") }
  let(:ct_meal) { create(:claim_type, name: "Meal expenses") }
  let(:claim_group1) do
    cg = build(:claim_group, :approved, employee:)
    cg.claims << build(:claim, employee:, claim_type: ct_travel, amount: Money.from_amount(20, "USD"))
    cg.save
    cg
  end
  let(:claim_group2) do
    cg = build(:claim_group, employee:)
    cg.claims << build(:claim, employee:, claim_type: ct_meal, amount: Money.from_amount(8, "USD"))
    cg.save
    cg
  end

  around do |example|
    travel_to(Time.zone.local(2023, 2)) { example.run }
  end

  before do
    DataVariables.company.update(finance_approver: manager)
    login(manager.account)
    claim_group1
    claim_group2
  end

  it "total filters" do
    visit team_claims_path
    expect(page).to(have_selector("h1", text: "Team Claims Management"))
    expect(page).to(have_current_path(team_claims_path))
    expect(find(
      :xpath,
      ".//form[@id='claim_group_search']/div",
    )).to(have_selector("div[data-controller='dropdown']", count: 4))
  end

  it "filter by id" do
    visit team_claims_path

    within :xpath, ".//form[@id='claim_group_search']/div/div[@data-controller='dropdown'][1]" do
      click_button("ID", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      fill_in("query[public_id_eq]", with: claim_group1.public_id)
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("ID: #{claim_group1.public_id}"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    expect(params["query"]["public_id_eq"]).to(eq(claim_group1.public_id))
    expect(find("turbo-frame#team-claim-groups-list")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by group name" do
    visit team_claims_path

    within :xpath, ".//form[@id='claim_group_search']/div/div[@data-controller='dropdown'][2]" do
      click_button("Group Name", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      fill_in("query[name_i_cont]", with: claim_group1.name)
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Group Name: #{claim_group1.name}"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    expect(params["query"]["name_i_cont"]).to(eq(claim_group1.name))
    expect(find("turbo-frame#team-claim-groups-list")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by total amount - equals" do
    visit team_claims_path

    within :xpath, ".//form[@id='claim_group_search']/div/div[@data-controller='dropdown'][3]" do
      click_button("Total amount", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select("equals", from: "query_c_p")
      fill_in("query_v", with: "8")
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Total amount: Equals $8"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    total_amount_query = params["query"]["c"].find { |x| x["a"].include?("total_amount") }
    expect(total_amount_query["p"]).to(eq("eq"))
    expect(total_amount_query["v"]).to(contain_exactly("8"))
    expect(find("turbo-frame#team-claim-groups-list")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by total amount - less than" do
    visit team_claims_path

    within :xpath, ".//form[@id='claim_group_search']/div/div[@data-controller='dropdown'][3]" do
      click_button("Total amount", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select("less than", from: "query_c_p")
      fill_in("query_v", with: "10")
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Total amount: Less than $10"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    total_amount_query = params["query"]["c"].find { |x| x["a"].include?("total_amount") }
    expect(total_amount_query["p"]).to(eq("lt"))
    expect(total_amount_query["v"]).to(contain_exactly("10"))
    expect(find("turbo-frame#team-claim-groups-list")).to(have_selector("table tbody tr", count: 1))
  end

  it "filter by total amount - greater than" do
    visit team_claims_path

    within :xpath, ".//form[@id='claim_group_search']/div/div[@data-controller='dropdown'][3]" do
      click_button("Total amount", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      select("greater than", from: "query_c_p")
      fill_in("query_v", with: "5")
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Total amount: Greater than $5"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    total_amount_query = params["query"]["c"].find { |x| x["a"].include?("total_amount") }
    expect(total_amount_query["p"]).to(eq("gt"))
    expect(total_amount_query["v"]).to(contain_exactly("5"))
    expect(find("turbo-frame#team-claim-groups-list")).to(have_selector("table tbody tr", count: 2))
  end

  it "filter by status" do
    visit team_claims_path

    within :xpath, ".//form[@id='claim_group_search']/div/div[@data-controller='dropdown'][4]" do
      click_button("Status", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      check("query_by_status_approved")
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("Status: Approved"))
    end

    url = URI.parse(page.current_url)
    params = Rack::Utils.parse_nested_query(url.query)
    expect(params["query"]["by_status"]).to(contain_exactly("approved"))
    expect(find("turbo-frame#team-claim-groups-list")).to(have_selector("table tbody tr", count: 1))
  end

  it "clear filters" do
    visit team_claims_path

    within :xpath, ".//form[@id='claim_group_search']/div/div[@data-controller='dropdown'][1]" do
      click_button("ID", name: "button")
      expect(page).to(have_selector("div[data-dropdown-target='menu']:not(.hidden)", visible: true))
      fill_in("query[public_id_eq]", with: claim_group1.public_id)
      click_button("Apply", name: "commit")
      expect(find("button[name='button'][type='button']")).to(have_content("ID: #{claim_group1.public_id}"))
    end

    expect(find("turbo-frame#team-claim-groups-list")).to(have_selector("table tbody tr", count: 1))

    within :xpath, ".//turbo-frame[@id='team-claim-groups-list']/div/div/form" do
      expect(page).to(have_button("Clear Filters"))
      click_button("Clear Filters")
      expect(page).not_to(have_button("Clear Filters"))
    end
  end
end
