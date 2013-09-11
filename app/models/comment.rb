# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  body             :text
#  created_at       :datetime
#  updated_at       :datetime
#  likes_count      :integer          default(0)
#

###############################################################################
#
#   Comment Model Class      
#
#   : Belongs to polymorphic `commentable` models 
#     (`belongs to` association)
#
###############################################################################

class Comment < ActiveRecord::Base

  # Apply Authorization to Comment Model (using Authority Gem) 
  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities

###############################################################################
##
##   Scopes of Model       
##
###############################################################################  

  default_scope -> {order(created_at: :asc)}

###############################################################################
##
##   Declaration of Model Associations
##
###############################################################################

  # Rolify Module method : has_many :roles
  resourcify
  
  # User who write a item
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  #belongs_to :user

  # Polymorphic association - belongs_to
  belongs_to :commentable, polymorphic: true, touch: true

  # Polymorphic association - has_many
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, class_name: 'User', foreign_key: :user_id, through: :likes,  source: :liker

end
