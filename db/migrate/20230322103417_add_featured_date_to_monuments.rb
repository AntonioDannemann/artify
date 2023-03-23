class AddFeaturedDateToMonuments < ActiveRecord::Migration[7.0]
  def change
    add_column :monuments, :featured_date, :date
  end
end
