class CreateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :monument, null: false, foreign_key: true
      t.string :description
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
