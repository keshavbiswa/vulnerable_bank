class Transaction < ApplicationRecord
  belongs_to :from_account, class_name: "Account"
  belongs_to :to_account, class_name: "Account"

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :transaction_type, presence: true

  enum :transaction_type, { transfer: "transfer", deposit: "deposit", withdrawal: "withdrawal", payment: "payment" }
  enum :status, { pending: "pending", completed: "completed", failed: "failed" }

  after_create :update_account_balances, if: :completed?

  private

  def update_account_balances
    from_account.decrement!(:balance, amount)
    to_account.increment!(:balance, amount)
  end
end
