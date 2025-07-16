# app/models/financer.rb
class Financer < User
  default_scope { where(role: :financer) }    # ← only financers, not platform_ops

  # All bids this financer has placed
  has_many :bids, foreign_key: :financer_id, dependent: :destroy

  # Invoices funded via accepted bids
  has_many :funded_invoices,
           -> { distinct.joins(:bids).where(bids: { status: :accepted }) },
           through: :bids,
           source: :invoice

  # Open invoices in tender state that this user hasn't bid on
  def opportunities
    Invoice
      .tendered
      .where.not(id: bids.select(:invoice_id))
  end
end
