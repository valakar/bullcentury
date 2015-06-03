class AddCountryYToProject < ActiveRecord::Migration
  def change
    add_reference :projects, :country, index: true
  end
end
