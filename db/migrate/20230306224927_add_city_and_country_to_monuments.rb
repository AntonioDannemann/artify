class AddCityAndCountryToMonuments < ActiveRecord::Migration[7.0]
  def change
    add_column :monuments, :city, :string
    add_column :monuments, :country, :string
    add_column :monuments, :country_code, :string
  end
end
