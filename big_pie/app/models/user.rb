class User < ActiveRecord::Base

  # Adds `can_create?(resource)`, etc
  include Authority::UserAbilities
  rolify
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, ProfileUploader       

  has_many :items, dependent: :destroy

  has_many :relationships, foreign_key: 'following_id', dependent: :destroy
  has_many :followers, through: :relationships, source: :follower
  has_many :reverse_relationships, foreign_key: 'follower_id',
           class_name: 'Relationship',
           dependent:   :destroy
  has_many :followings, through: :reverse_relationships, source: :following

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_items, class_name: "Item", through: :likes, source: :likeable, source_type: "Item"

  has_many :associates
  has_many :communities, :through => :associates


  def like!(item)
    likes.create!( likeable: item)
  end

  def dislike!(item)
    likes.find_by(likeable: item).destroy!
  end

  def liking?(item)
    if item.nil?
      false
    else
      likes.find_by(likeable: item).present?
    end
  end

  def following?(other_user)
    if other_user.nil?
      false
    else
      relationships.find_by(follower_id: other_user.id).present?
    end
  end

  def follow!(other_user)
    relationships.create!(follower_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(follower_id: other_user.id).destroy!
  end
end
