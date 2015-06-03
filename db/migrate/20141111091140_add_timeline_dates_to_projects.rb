class AddTimelineDatesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :timeline_date1, :datetime
    add_column :projects, :timeline_date2, :datetime
    add_column :projects, :timeline_date3, :datetime
  end
end
