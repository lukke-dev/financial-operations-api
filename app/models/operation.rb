class Operation < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :amount, presence: true
  validates :status, presence: true
  validates :currency, presence: true

  enum status: { received: 0, processed: 1 }
  enum currency: { usd: 0, brl: 1, eur: 2 }
end
