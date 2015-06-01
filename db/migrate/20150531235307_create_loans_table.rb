class CreateLoansTable < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.belongs_to :user
      t.string :borrower_name
      t.string :description
      t.datetime :application_date
      t.datetime :disclose_by_date
      t.datetime :earliest_closing_date

      t.timestamps
    end
  end
end
