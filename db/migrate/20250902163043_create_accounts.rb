class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :account_number
      t.string :account_type
      t.decimal :balance
      t.string :status

      t.timestamps
    end
  end
end
