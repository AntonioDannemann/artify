class CreateArchitectMonuments < ActiveRecord::Migration[7.0]
  def change
    create_table :architect_monuments do |t|
      t.references :architect, null: false, foreign_key: true
      t.references :monument, null: false, foreign_key: true

      t.timestamps
    end
  end
end
