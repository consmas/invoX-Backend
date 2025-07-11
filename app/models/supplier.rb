class Supplier < ApplicationRecord
    belongs_to :user
    has_many :invoices, dependent: :nullify
    has_many :programmes, through: :invoices
    has_many :buyers, through: :programmes

    validates :name, :email, presence: true
   
    before_create :generate_invitation_token

    private

    def generate_invitation_token
        self.invitation_token = SecureRandom.hex(20)
        self.invited_at        = Time.current
    end
end
