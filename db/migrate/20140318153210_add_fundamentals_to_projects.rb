class AddFundamentalsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :tweet, :string, limit: 140
    add_column :projects, :funding_duration_in_days, :integer
    add_column :projects, :funding_goal, :integer
  end
end
