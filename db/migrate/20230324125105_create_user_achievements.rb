class CreateUserAchievements < ActiveRecord::Migration[7.0]
  def change
    create_table :user_achievements do |t|
      t.references :user, null: false, foreign_key: true
      t.references :achievement, null: false, foreign_key: true
      t.string :status, default: "in progress"
      t.integer :progress, default: 0
      t.date :completion_date

      t.timestamps
    end
  end
end
