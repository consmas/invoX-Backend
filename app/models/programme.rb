class Programme < ApplicationRecord
  belongs_to :buyer
  has_many :invoices
  has_many :suppliers, -> { where(users: { role: :supplier_user }) },
           through: :invoices, source: :supplier
end
