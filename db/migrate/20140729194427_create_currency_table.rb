class CreateCurrencyTable < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :key, :limit => 4
      t.string :sign, :limit => 2
    end
  end
end
