class RemoveLatAndLngFromHistories < ActiveRecord::Migration[7.0]
  def change
    remove_column :histories, :lat, :float
    remove_column :histories, :lng, :float
  end
end
