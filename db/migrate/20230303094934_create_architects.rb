class CreateArchitects < ActiveRecord::Migration[7.0]
  def change
    create_table :architects do |t|
      t.string :name
      t.date :birth_date
      t.date :death_date
      t.string :nationality
      t.string :description

      t.timestamps
    end
  end
end
