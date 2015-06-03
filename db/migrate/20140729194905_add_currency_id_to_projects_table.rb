class AddCurrencyIdToProjectsTable < ActiveRecord::Migration
  def change
    add_column :projects, :currency_id, :integer
  end
end
