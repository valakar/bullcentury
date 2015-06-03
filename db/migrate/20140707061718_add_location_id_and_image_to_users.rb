class AddLocationIdAndImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location_id, :integer
    add_column :users, :image, :string
  end
end
