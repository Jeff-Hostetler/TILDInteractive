require "rails_helper"

describe "Loans API" do
  describe "#index" do
    it "returns a list of loans that belong to a user" do
      user = TestObjectFactory.create_user

      Loan.create(
          user: user,
          borrower_name: "Smith",
          description: "The one for the Smiths",
          application_date: Time.now,
          disclose_by_date: Time.now + 1.day,
          earliest_closing_date: Time.now + 15.days
      )

      Loan.create(
          user: user,
          borrower_name: "Hos",
          description: "The one for the Hos Boss",
          application_date: Time.now+1.day,
          disclose_by_date: Time.now + 2.days,
          earliest_closing_date: Time.now + 15.days
      )

      authenticated_get "/users/#{user.id}/loans/",
                        params = {},
                        headers = {},
                        options = {email: user.email, password: user.password}

      results = JSON.parse(response.body, symbolize_names: true)

      expect(results.first.keys).to match_array([
                                                    :id,
                                                    :borrower_name,
                                                    :description,
                                                    :application_date,
                                                    :disclose_by_date,
                                                    :earliest_closing_date
                                                ])

      expect(results.length).to eq 2

      expect(results.first[:borrower_name]).to eq "Smith"
      expect(results.first[:description]).to eq "The one for the Smiths"
      expect(results.first[:application_date]).to be_within(1.second).of(Time.now)
      expect(results.first[:disclose_by_date]).to be_within(1.second).of(Time.now + 1.day)
      expect(results.first[:earliest_closing_date]).to be_within(1.second).of(Time.now + 15.days)

      expect(results.last[:borrower_name]).to eq "Hos"
      expect(results.first[:description]).to eq "The one for Hos Boss"
      expect(results.first[:application_date]).to be_within(1.second).of(Time.now + 1.day)
      expect(results.first[:disclose_by_date]).to be_within(1.second).of(Time.now + 2.days)
      expect(results.first[:earliest_closing_date]).to be_within(1.second).of(Time.now + 15.days)
    end
  end
end