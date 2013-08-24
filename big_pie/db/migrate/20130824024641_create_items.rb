class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :user, index: true
      t.string :photo
      t.string :url_ref
      t.string :description
      t.integer :starts_count, :default => 0

      t.timestamps
    end
  end
end
