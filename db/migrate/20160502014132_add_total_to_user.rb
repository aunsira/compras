class AddTotalToUser < ActiveRecord::Migration
  def change
    add_column :users, :total, :decimal, precision: 7, scale: 2
  end
end
