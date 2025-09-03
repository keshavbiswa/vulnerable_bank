require 'rails_helper'

RSpec.describe 'A08:2021 - Software and Data Integrity Failures', type: :request do
  before do
    setup_test_data
  end

  it 'I should not be able to send $10 but charge $500 somehow?' do
    login_as(@user)

    original_balance = @account.balance
    to_balance = @other_account.balance

    post '/api/v1/transfer',
         params: {
           from_account_id: @account.id,
           to_account_id: @other_account.id,
           amount: 10.00,
           actual_amount: 500.00
         },
         headers: { 'Authorization' => "Bearer #{@user.id}" }

    @account.reload

    expected_balance = (original_balance - 10.00).to_f
    expected_to_balance = (to_balance + 10.00).to_f
    expect(@account.balance.to_f).to eq(expected_balance)
    expect(@other_account.balance.to_f).to eq(expected_to_balance)
  end
end
