class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lastname, :string
    add_column :users, :company, :string
    add_column :users, :birthday, :date
    add_column :users, :mobile, :string
    add_column :users, :phone, :string
    add_column :users, :email_backup, :string
  end
end
