class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_number
      t.decimal :amount, precision: 10, scale: 2
      t.date :due_date
      t.string :status
      t.references :programme, null: false, foreign_key: true
      t.references :supplier, null: false, foreign_key: true

      t.timestamps
    end
  end
end
