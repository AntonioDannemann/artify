class CreateMonuments < ActiveRecord::Migration[7.0]
  def change
    create_table :monuments do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.string :description
      t.date :completion_date
      t.string :location
      t.string :style
      t.string :website_url

      t.timestamps
    end
  end
end
