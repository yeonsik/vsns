class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.references :follower, index: true
      t.references :following, index: true

      t.timestamps
    end
    # add_index :relationships, [:follower_id, :following_id], unique: true
  end
end

