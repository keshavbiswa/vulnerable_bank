class Admin::DashboardController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @total_users = User.count
    @total_accounts = Account.count
    @total_transactions = Transaction.count
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_transactions = Transaction.order(created_at: :desc).limit(10)
  end
end
