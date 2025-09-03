class Account < ApplicationRecord
  belongs_to :user
  has_many :from_transactions, class_name: "Transaction", foreign_key: "from_account_id", dependent: :destroy
  has_many :to_transactions, class_name: "Transaction", foreign_key: "to_account_id", dependent: :destroy

  validates :account_number, presence: true, uniqueness: true
  validates :account_type, presence: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum :account_type, { checking: "checking", savings: "savings", credit: "credit" }
  enum :status, { active: "active", suspended: "suspended", closed: "closed" }

  before_validation :generate_account_number, on: :create

  def all_transactions
    Transaction.where("from_account_id = ? OR to_account_id = ?", id, id)
  end

  private

  def generate_account_number
    self.account_number ||= "ACC#{SecureRandom.hex(6).upcase}"
  end
end
