class LoanListSerializer < ActiveModel::Serializer
  attributes :id,
             :borrower_name,
             :description,
             :application_date,
             :disclose_by_date,
             :earliest_closing_date
end