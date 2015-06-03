class CreatePledgeTransactions < ActiveRecord::Migration
  def change
    create_table :pledge_transactions do |t|
      t.text :transaction_id
      t.references :user
      t.references :project
      t.references :currency
      t.integer :amount

      t.timestamps
    end
  end
end
