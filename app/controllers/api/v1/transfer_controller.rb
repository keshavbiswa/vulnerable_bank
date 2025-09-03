class Api::V1::TransferController < Api::V1::BaseController
  def create
    from_account = Account.find(params[:from_account_id])
    to_account = Account.find(params[:to_account_id])
    amount = params[:amount].to_f

    actual_amount = params[:actual_amount]&.to_f || amount

   puts "actual_amount: #{actual_amount}"

     if from_account.balance >= actual_amount
      from_account.update!(balance: from_account.balance - actual_amount)
      to_account.update!(balance: to_account.balance + actual_amount)

      transaction = Transaction.create!(
        from_account: from_account,
        to_account: to_account,
        amount: amount,
        description: params[:description] || "Transfer",
        transaction_type: "transfer",
        status: "completed"
      )

      render json: { success: true, transaction_id: transaction.id }
     else
       render json: { error: "Insufficient funds" }, status: 400
     end
  end
end
