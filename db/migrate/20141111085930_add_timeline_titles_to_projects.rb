class AddTimelineTitlesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :timeline1, :string
    add_column :projects, :timeline2, :string
    add_column :projects, :timeline3, :string
  end
end
