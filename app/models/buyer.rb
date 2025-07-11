class Buyer < ApplicationRecord

    has_many :users, foreign_key: :buyer_id, dependent: :nullify
    has_many :programmes, dependent: :destroy
    has_many :invoices, through: :programmes

    has_many :suppliers, -> { where(users: { role: :supplier_user }) },
           through: :invoices, source: :supplier

    # allow nested creation of its users
    accepts_nested_attributes_for :users

    validates :name, :registration_number, :contact_email, presence: true

end
