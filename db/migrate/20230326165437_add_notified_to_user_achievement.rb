class AddNotifiedToUserAchievement < ActiveRecord::Migration[7.0]
  def change
    add_column :user_achievements, :notified, :boolean, default: false
  end
end
