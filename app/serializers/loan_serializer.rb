class LoanSerializer < ActiveModel::Serializer
  attributes :id,
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
end