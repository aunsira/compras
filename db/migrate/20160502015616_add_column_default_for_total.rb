class AddColumnDefaultForTotal < ActiveRecord::Migration
  def change
    change_column_default :users, :total, 0.0
  end
end
