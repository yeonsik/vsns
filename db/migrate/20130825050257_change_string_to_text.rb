# items 테이블의 description 데이터형을 string에서 text형으로 변경함. by hschoi

class ChangeStringToText < ActiveRecord::Migration
  def up
    change_column :items, :description, :text
  end
  def down
    change_column :items, :description, :string
  end
end
