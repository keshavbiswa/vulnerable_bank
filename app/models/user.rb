class User < ApplicationRecord
  has_secure_password
  has_many :accounts, dependent: :destroy
  has_many :transactions, through: :accounts, source: :from_transactions

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true

  enum :role, { customer: "customer", admin: "admin", employee: "employee" }

  def full_name
    "#{first_name} #{last_name}"
  end

  def total_balance
    accounts.sum(:balance) || 0.0
  end
end
