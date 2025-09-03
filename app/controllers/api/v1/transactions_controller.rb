class Api::V1::TransactionsController < Api::V1::BaseController
  def transfer
    from_account_id = params[:from_account_id]
    to_account_id = params[:to_account_id]
    amount = params[:amount].to_f
    description = params[:description]

    from_account = Account.find(from_account_id)
    to_account = Account.find(to_account_id)

    if from_account.balance >= amount
      from_account.update!(balance: from_account.balance - amount)
      to_account.update!(balance: to_account.balance + amount)

      transaction = Transaction.create!(
        from_account: from_account,
        to_account: to_account,
        amount: amount,
        description: description,
        transaction_type: "transfer",
        status: "completed"
      )

      render json: {
        status: "success",
        transaction: transaction,
        from_account_balance: from_account.reload.balance,
        to_account_balance: to_account.reload.balance
      }
    else
      render json: { status: "error", message: "Insufficient funds" }, status: 400
    end

  rescue ActiveRecord::RecordNotFound
    render json: { status: "error", message: "Account not found" }, status: 404
  rescue => e
    render json: { status: "error", message: e.message, backtrace: e.backtrace }, status: 500
  end
end
