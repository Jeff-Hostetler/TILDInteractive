require "rails_helper"

describe ImportantDateService do
  let(:service) {ImportantDateService.new}
  describe "#create" do
    it "sets the disclose_by_date and earliest_closing_date" do
      result = service.create("2015-06-11T00:00:00.000Z")

      expect(result).to eq ({
                               application_date: DateTime.new(2015, 6, 11),
                               disclose_by_date: DateTime.new(2015, 6, 15),
                               earliest_closing_date: DateTime.new(2015, 6, 23)
                           })
    end
  end

  describe "#update" do
    it "updates the earliest_closing_date when disclosures_delivered_date is updated" do
      disclosure_dates = {
          application_date: "2015-06-11T00:00:00.000+00:00",
          earliest_closing_date: "2015-06-23aT00:00:00.000+00:00",
          disclosures_delivered_date: "2015-06-11T00:00:00.000+00:00"
      }
      result = service.update(disclosure_dates)

      #TODO think about what to return from update. Hash of dates that are not nil?
    end
  end
end