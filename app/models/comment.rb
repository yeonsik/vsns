class Comment < ActiveRecord::Base

  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities
  resourcify
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, through: :likes,  source: :user

  default_scope -> {order(created_at: :asc)}
end
