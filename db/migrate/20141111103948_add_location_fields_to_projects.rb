class AddLocationFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :country, :string
    add_column :projects, :city, :string
    add_column :projects, :region, :string
    add_column :projects, :zip, :integer
    add_column :projects, :address, :string
  end
end
