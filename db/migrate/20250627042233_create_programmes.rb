class CreateProgrammes < ActiveRecord::Migration[8.0]
  def change
    create_table :programmes do |t|
      t.references :buyer, null: false, foreign_key: true
      t.string :name
      t.decimal :limit
      t.decimal :fee_percent
      t.integer :maturity_days

      t.timestamps
    end
  end
end
