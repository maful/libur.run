# frozen_string_literal: true

require("rails_helper")

RSpec.describe(Dashboard::HomeController) do
  context "with unauthenticated" do
    it "unable to access" do
      get :index

      expect(response).to(redirect_to("/login"))
      expect(response).to(have_http_status(:found))
    end
  end

  context "with onboarding completed" do
    let(:account) { create(:account, :verified, with_employee: true) }

    before do
      login(account)
    end

    it "able to access" do
      get :index

      expect(response).to(have_http_status(:ok))
    end
  end
end
