require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let!(:company) { create(:company) }
  let(:account) { create(:account, with_employee: true) }
  let(:employee) { account.employee }

  describe "invite" do
    let(:mail) { UserMailer.with(employee_id: employee.id).invite }

    it "renders the headers" do
      expect(mail.subject).to eq("You have been invited!")
      expect(mail.to).to eq([account.email])
      expect(mail.from).to eq(["noreply@libur.run"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Please click the button below to accept this invitation")
    end
  end
end
