class RemoveCityFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :city, :string
  end
end
