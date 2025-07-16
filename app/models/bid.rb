class Bid < ApplicationRecord
  belongs_to :invoice
  belongs_to :financer, class_name: "User"

  # ── canonical enum syntax ─────────────────────────────────────────
  enum :status, { pending: 0, accepted: 1, rejected: 2, expired: 3 }

  validates :amount, :status, presence: true
  validate  :expiry_in_future, if: -> { expiry_date.present? }

  after_initialize do
    self.status ||= :pending
  end

  private

  def expiry_in_future
    errors.add(:expiry_date, "must be in the future") if expiry_date < Date.today
  end
end
