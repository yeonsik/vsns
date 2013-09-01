class AddOwnerToCommunities < ActiveRecord::Migration
  def change
    add_reference :communities, :owner, index: true
  end
end
