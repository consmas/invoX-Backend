class AddStatusToInvoices < ActiveRecord::Migration[8.0]
  def change
    return if column_exists?(:invoices, :status)

    add_column :invoices, :status, :integer, default: 0, null: false
  end
end
