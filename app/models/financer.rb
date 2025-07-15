# Single‐table inheritance on User for clarity & scoping
class Financer < User
  default_scope { where(role: :financer) }

  # All bids this financer has placed
  has_many :bids, foreign_key: :financer_id, dependent: :destroy

  # All invoices this financer has funded (i.e. where one of their bids was accepted)
  has_many :funded_invoices,
           -> { distinct.joins(:bids).where(bids: { status: :accepted }) },
           through: :bids,
           source: :invoice
end
