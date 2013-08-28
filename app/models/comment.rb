class Comment < ActiveRecord::Base

  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities
  resourcify
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  default_scope -> {order(created_at: :asc)}
end
