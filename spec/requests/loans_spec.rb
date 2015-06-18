require "rails_helper"

describe "Loans API" do
  let(:user) { TestObjectFactory.create_user }
  describe "#index" do
    it "returns a list of loans that belong to a user" do
      another_user = TestObjectFactory.create_user

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

      Loan.create(user: another_user)

      authenticated_get "/users/#{user.id}/loans/",
                        params = {},
                        headers = {},
                        options = {email: user.email, password: user.password}

      results = JSON.parse(response.body, symbolize_names: true)[:loans]

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
      expect(Time.parse(results.first[:application_date])).to be_within(1.second).of(Time.now)
      expect(Time.parse(results.first[:disclose_by_date])).to be_within(1.second).of(Time.now + 1.day)
      expect(Time.parse(results.first[:earliest_closing_date])).to be_within(1.second).of(Time.now + 15.days)

      expect(results.last[:borrower_name]).to eq "Hos"
      expect(results.last[:description]).to eq "The one for the Hos Boss"
      expect(Time.parse(results.last[:application_date])).to be_within(1.second).of(Time.now + 1.day)
      expect(Time.parse(results.last[:disclose_by_date])).to be_within(1.second).of(Time.now + 2.days)
      expect(Time.parse(results.last[:earliest_closing_date])).to be_within(1.second).of(Time.now + 15.days)
    end
  end

  describe "#create" do
    it "creates a loan for said user" do
      params = {
          borrower_name: "Smith",
          description: "Favorite borrowers",
          application_date: DateTime.new(2015, 6, 11),
      }.to_json

      authenticated_post "/users/#{user.id}/loans/",
                         params = params,
                         headers = {},
                         options = {email: user.email, password: user.password}

      expect(response.status).to eq 200

      expect(Loan.where(user: user).count).to eq 1

      result = JSON.parse(response.body, symbolize_names: true)[:loan]

      expect(result[:borrower_name]).to eq "Smith"
      expect(result[:description]).to eq "Favorite borrowers"
      expect(result[:application_date]).to eq "2015-06-11T00:00:00.000Z"
      expect(result[:disclose_by_date]).to eq "2015-06-15T00:00:00.000Z"
      expect(result[:earliest_closing_date]).to eq "2015-06-23T00:00:00.000Z"
      expect(result[:disclosures_delivered_date]).to eq nil
      expect(result[:disclosures_received_date]).to eq nil
      expect(result[:change_of_circumstance_date]).to eq nil
      expect(result[:revised_disclosures_delivered_date]).to eq nil
      expect(result[:revised_disclosures_received_date]).to eq nil
      expect(result[:closing_disclosures_delivered_date]).to eq nil
      expect(result[:closing_disclosures_received_date]).to eq nil
    end
  end

  describe "#show" do
    let(:loan) { Loan.create(user: user,
                             borrower_name: "Richards",
                             description: "New loan"
    ) }
    it "responds with the requested loan" do
      authenticated_get "/users/#{user.id}/loans/#{loan.id}",
                        params = params,
                        headers = {},
                        options = {email: user.email, password: user.password}

      result = JSON.parse(response.body, symbolize_names: true)[:loan]

      expect(result.keys).to match_array([
                                             :id,
                                             :borrower_name,
                                             :description,
                                             :application_date,
                                             :disclosures_delivered_date,
                                             :disclosures_received_date,
                                             :disclose_by_date,
                                             :change_of_circumstance_date,
                                             :revised_disclosures_delivered_date,
                                             :revised_disclosures_received_date,
                                             :closing_disclosures_delivered_date,
                                             :closing_disclosures_received,
                                             :earliest_closing_date
                                         ])

      expect(result[:borrower_name]).to eq "Richards"
      expect(result[:description]).to eq "New loan"
      expect(result[:application_date]).to eq nil
      expect(result[:disclosures_delivered_date]).to eq nil
      expect(result[:disclosures_received_date]).to eq nil
      expect(result[:disclose_by_date]).to eq nil
      expect(result[:change_of_circumstance_date]).to eq nil
      expect(result[:revised_disclosures_delivered_date]).to eq nil
      expect(result[:revised_disclosures_received_date]).to eq nil
      expect(result[:closing_disclosures_delivered_date]).to eq nil
      expect(result[:closing_disclosures_received]).to eq nil
      expect(result[:earliest_closing_date]).to eq nil
    end

    it "renders an error if the loan does not belong to user" do
      another_user = TestObjectFactory.create_user

      authenticated_get "/users/#{user.id}/loans/#{loan.id}",
                        params = params,
                        headers = {},
                        options = {email: another_user.email,
                                   password: another_user.password
                        }

      expect(response.status).to eq 401

      result = JSON.parse(response.body, symbolize_names: true)[:loans]

      expect(result).to match_array("Page is unauthorized or does not exist.")
    end
  end

  describe"#update" do
    let(:loan) { Loan.create(user: user,
                             borrower_name: "Richards",
                             description: "New loan",
                             application_date: DateTime.new(2015, 6, 11),
                             earliest_closing_date: Date.new(2015, 6, 23)

    ) }
    it "updates a loan" do
      params = {
          borrower_name: "Smith",
          description: "Favorite borrowers",
          disclosures_delivered_date: DateTime.new(2015, 6, 11),
          disclosures_received_date: DateTime.new(2015, 6, 12)
      }.to_json

      authenticated_put "/users/#{user.id}/loans/#{loan.id}",
                         params = params,
                         headers = {},
                         options = {email: user.email, password: user.password}

      expect(response.status).to eq 200

      result = JSON.parse(response.body, symbolize_name: true)[:loan]

      expect(result[:borrower_name]).to eq "Smith"
      expect(result[:description]).to eq "Favorite borrowers"
      expect(result[:application_date]).to eq "2015-06-11T00:00:00.000Z"
      expect(result[:disclose_by_date]).to eq "2015-06-15T00:00:00.000Z"
      expect(result[:earliest_closing_date]).to eq "2015-06-19T00:00:00.000Z"
      expect(result[:disclosures_delivered_date]).to eq "2015-06-11T00:00:00.000Z"
      expect(result[:disclosures_received_date]).to eq "2015-06-12T00:00:00.000Z"
      expect(result[:change_of_circumstance_date]).to eq nil
      expect(result[:revised_disclosures_delivered_date]).to eq nil
      expect(result[:revised_disclosures_received_date]).to eq nil
      expect(result[:closing_disclosures_delivered_date]).to eq nil
      expect(result[:closing_disclosures_received_date]).to eq nil
    end

    it "updates the "

    it "does not allow app, disclose_by, earliest_closing, to be updated"

    it "renders an error if attempting to update another users loan"
  end
end