class AddLatAndLngToHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :histories, :lat, :float
    add_column :histories, :lng, :float
  end
end
