class RemoveCountryFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :country, :string
  end
end
