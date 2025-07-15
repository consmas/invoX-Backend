class CreateBids < ActiveRecord::Migration[8.0]
  def change
    create_table :bids do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :financer, null: false, foreign_key: { to_table: :users }
      t.decimal    :amount, precision: 15, scale: 2, null: false
      t.integer    :status, default: 0, null: false  # enum
      t.date       :expiry_date
      t.timestamps
    end
  end
end