class AddLikesCountToItems < ActiveRecord::Migration
  def change
    add_column :items, :likes_count, :integer, default: 0
  end
end
