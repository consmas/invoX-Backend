class AddDetailsToBuyers < ActiveRecord::Migration[8.0]
  def change
    add_column :buyers, :registration_number, :string, null: false, default: ""
    add_column :buyers, :address,             :string, null: false, default: ""
    add_column :buyers, :contact_email,       :string, null: false, default: ""
  end
end
