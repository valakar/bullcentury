class AddEmailToPledgeTransactions < ActiveRecord::Migration
  def change
    add_column :pledge_transactions, :email, :string
  end
end
