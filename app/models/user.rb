class User < ApplicationRecord

  belongs_to :buyer, optional: true
  
  enum :role, { buyer_admin: 0, supplier_user: 1, platform_ops: 2, financer: 3 }

  # if this user is a supplier_user, they “fulfill” invoices
  has_many :invoices, foreign_key: :supplier_id, dependent: :nullify
  has_many :programmes, through: :invoices
  has_many :buyers, -> { distinct }, through: :programmes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  before_create { self.jti ||= SecureRandom.uuid }

  # jwt_revocation_strategy :self helpers
  def self.jwt_revoked?(payload, user) = payload["jti"] != user.jti
  def self.revoke_jwt(_payload, user)  = user.update!(jti: SecureRandom.uuid)
  
end
