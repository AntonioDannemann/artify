class AddKeywordToAchievement < ActiveRecord::Migration[7.0]
  def change
    add_column :achievements, :keyword, :string
  end
end
