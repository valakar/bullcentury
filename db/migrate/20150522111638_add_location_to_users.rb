class AddLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zip, :integer
    add_column :users, :address, :string
    add_reference :users, :country, index: true
  end
end
