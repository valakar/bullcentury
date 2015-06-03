class AddQuickToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :quick, :boolean, :default => false
  end
end
