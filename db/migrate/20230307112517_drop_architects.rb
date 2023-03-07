class DropArchitects < ActiveRecord::Migration[7.0]
  def change
    drop_table :Architects
  end
end
