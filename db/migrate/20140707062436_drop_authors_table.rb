class DropAuthorsTable < ActiveRecord::Migration
  def change
    remove_column :projects, :author_id
    drop_table :authors
  end
end
