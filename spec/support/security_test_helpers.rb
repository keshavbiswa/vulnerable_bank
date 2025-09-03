module SecurityTestHelpers
  def login_as(user)
    post '/login', params: {
      email: user.email,
      password: 'password123'
    }
    follow_redirect! if response.redirect?
  end

  def create_test_users
    @admin_user = User.create!(
      email: 'admin@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      first_name: 'Admin',
      last_name: 'User',
      role: 'admin',
      admin: true
    )

    @user = User.create!(
      email: 'user@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      first_name: 'John',
      last_name: 'Doe',
      role: 'customer'
    )

    @other_user = User.create!(
      email: 'other@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      first_name: 'Other',
      last_name: 'User',
      role: 'customer'
    )
  end

  def create_test_accounts
    @account = Account.create!(
      user: @user,
      account_type: 'checking',
      balance: 1000.0
    )

    @other_account = Account.create!(
      user: @other_user,
      account_type: 'savings',
      balance: 500.0
    )

    @admin_account = Account.create!(
      user: @admin_user,
      account_type: 'checking',
      balance: 10000.0
    )
  end

  def create_test_transactions
    @transaction = Transaction.create!(
      from_account: @account,
      to_account: @other_account,
      amount: 100.0,
      description: 'Test transfer',
      transaction_type: 'transfer',
      status: 'completed'
    )
  end

  def setup_test_data
    create_test_users
    create_test_accounts
    create_test_transactions
  end
end

RSpec.configure do |config|
  config.include SecurityTestHelpers, type: :request
  config.include SecurityTestHelpers, type: :system
end
