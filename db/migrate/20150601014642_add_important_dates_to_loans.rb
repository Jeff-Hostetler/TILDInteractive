class AddImportantDatesToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :disclosures_delivered_date, :datetime
    add_column :loans, :disclosures_received_date, :datetime
    add_column :loans, :change_of_circumstance_date, :datetime
    add_column :loans, :revised_disclosures_delivered_date, :datetime
    add_column :loans, :revised_disclosures_received_date, :datetime
    add_column :loans, :closing_disclosures_delivered_date, :datetime
    add_column :loans, :closing_disclosures_received, :datetime
  end
end
