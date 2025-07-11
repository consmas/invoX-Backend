class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :email
      t.string :company
      t.datetime :invited_at
      t.string :invitation_token

      t.timestamps
    end
    add_index :suppliers, :email, unique: true
  end
end