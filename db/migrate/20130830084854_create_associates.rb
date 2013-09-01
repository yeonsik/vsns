class CreateAssociates < ActiveRecord::Migration
  def change
    create_table :associates do |t|
      t.references :user, index: true
      t.references :community, index: true
      t.string :access_type

      t.timestamps
    end
  end
end
