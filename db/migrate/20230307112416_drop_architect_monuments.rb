class DropArchitectMonuments < ActiveRecord::Migration[7.0]
  def change
    drop_table :architect_monuments
  end
end
