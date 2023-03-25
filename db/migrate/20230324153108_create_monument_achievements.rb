class CreateMonumentAchievements < ActiveRecord::Migration[7.0]
  def change
    create_table :monument_achievements do |t|
      t.references :achievement, null: false, foreign_key: true
      t.references :monument, null: false, foreign_key: true

      t.timestamps
    end
  end
end
