class CreateAchievements < ActiveRecord::Migration[7.0]
  def change
    create_table :achievements do |t|
      t.string :title
      t.string :description
      t.integer :goal

      t.timestamps
    end
  end
end
