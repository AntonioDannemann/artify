class RemoveDateAndStyleFromMonuments < ActiveRecord::Migration[7.0]
  def change
    remove_column :monuments, :completion_date, :data
    remove_column :monuments, :style, :string
  end
end
