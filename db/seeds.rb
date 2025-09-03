# Create test users
puts "Creating test users..."

admin_user = User.create!(
  email: 'admin@vulnerablebank.com',
  password: 'admin123',
  password_confirmation: 'admin123',
  first_name: 'Bank',
  last_name: 'Administrator',
  role: 'admin',
  admin: true
)

customer1 = User.create!(
  email: 'alice@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Alice',
  last_name: 'Johnson',
  role: 'customer',
  admin: false
)

customer2 = User.create!(
  email: 'bob@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Bob',
  last_name: 'Smith',
  role: 'customer',
  admin: false
)

customer3 = User.create!(
  email: 'carol@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Carol',
  last_name: 'Williams',
  role: 'customer',
  admin: false
)

puts "Created #{User.count} users"

# Create accounts for each customer
puts "Creating accounts..."

alice_checking = Account.create!(
  user: customer1,
  account_type: 'checking',
  balance: 5000.00,
  status: 'active'
)

alice_savings = Account.create!(
  user: customer1,
  account_type: 'savings',
  balance: 15000.00,
  status: 'active'
)

bob_checking = Account.create!(
  user: customer2,
  account_type: 'checking',
  balance: 2500.00,
  status: 'active'
)

bob_credit = Account.create!(
  user: customer2,
  account_type: 'credit',
  balance: 0.00,
  status: 'active'
)

carol_checking = Account.create!(
  user: customer3,
  account_type: 'checking',
  balance: 3750.00,
  status: 'active'
)

carol_savings = Account.create!(
  user: customer3,
  account_type: 'savings',
  balance: 8200.00,
  status: 'active'
)

puts "Created #{Account.count} accounts"

# Create some sample transactions
puts "Creating sample transactions..."

Transaction.create!(
  from_account: alice_checking,
  to_account: bob_checking,
  amount: 250.00,
  description: 'Rent payment',
  transaction_type: 'transfer',
  status: 'completed'
)

Transaction.create!(
  from_account: bob_checking,
  to_account: carol_checking,
  amount: 100.00,
  description: 'Dinner split',
  transaction_type: 'transfer',
  status: 'completed'
)

Transaction.create!(
  from_account: carol_savings,
  to_account: alice_savings,
  amount: 500.00,
  description: 'Loan repayment',
  transaction_type: 'transfer',
  status: 'completed'
)

Transaction.create!(
  from_account: alice_savings,
  to_account: alice_checking,
  amount: 1000.00,
  description: 'Transfer to checking',
  transaction_type: 'transfer',
  status: 'completed'
)

puts "Created #{Transaction.count} transactions"

puts "Database seeded successfully!"
puts ""
puts "Test users created:"
puts "- Admin: admin@vulnerablebank.com / admin123"
puts "- Alice: alice@example.com / password123"
puts "- Bob: bob@example.com / password123"
puts "- Carol: carol@example.com / password123"
