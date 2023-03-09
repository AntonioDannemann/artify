class RemoveLngAndLatFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :lat, :float
    remove_column :users, :lng, :float
  end
end
