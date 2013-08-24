class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, ProfileUploader       

  has_many :relationships, foreign_key: 'following_id', dependent: :destroy
  has_many :followers, through: :relationships, source: :follower
  has_many :reverse_relationships, foreign_key: 'follower_id',
           class_name: 'Relationship',
           dependent:   :destroy
  has_many :followings, through: :reverse_relationships, source: :following

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
