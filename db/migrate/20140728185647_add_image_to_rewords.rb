class AddImageToRewords < ActiveRecord::Migration
  def change
    add_column :rewards, :image, :string
  end
end
