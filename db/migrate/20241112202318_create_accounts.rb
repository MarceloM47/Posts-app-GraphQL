class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :account_type
      t.string :company_number
      t.date :date_of_birth

      t.timestamps
    end
    add_index :accounts, :email, unique: true
  end
end
