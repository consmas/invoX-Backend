# app/models/invoice.rb
class Invoice < ApplicationRecord
  belongs_to :programme
  belongs_to :supplier, class_name: 'User', optional: true

  has_many :bids, dependent: :destroy

  # —– THE CANONICAL AR::Enum SYNTAX —––––––––––––––––––––––––––––––––––––––––
  enum :status, { 
    draft:    0,
    approved: 1,
    tender:   2,
    funded:   3,
    repaid:   4
  }

  scope :tendered, -> { where(status: statuses[:tender]) }
  scope :funded,   -> { where(status: statuses[:funded]) }
end
