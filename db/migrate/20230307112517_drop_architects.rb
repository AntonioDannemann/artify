class DropArchitects < ActiveRecord::Migration[7.0]
  def change
    drop_table :architects
  end
end
