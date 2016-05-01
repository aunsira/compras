class AddProduct < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :value, precision: 7, scale: 2

      t.timestamps null: false
    end
  end
end
