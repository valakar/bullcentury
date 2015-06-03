class AddCreatorBiographyToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :creator_biography, :text
  end
end
