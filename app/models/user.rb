###############################################################################
#
#   User Model Class      
#
###############################################################################

class User < ActiveRecord::Base

  # Adds `can_create?(resource)`, etc
  include Authority::UserAbilities

  # Associate User to Role Model (with Rolify Gem)
  # You should resourcify some model you want to grant 
  rolify
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # add username
  validates_presence_of   :username
  validates_uniqueness_of :username

  # Connect avatar attribute to Carrierwave Uploader.
  mount_uploader :avatar, ProfileUploader  

###############################################################################
##
##   Declaration of Model Associations
##
###############################################################################

  # A user has many items.
  has_many :items, dependent: :destroy

  # A user has many comments.
  has_many :comments, dependent: :destroy

  # to declare associations for 'following' functionality
  has_many :relationships, foreign_key: 'following_id', dependent: :destroy
  has_many :followers, through: :relationships, source: :follower

  has_many :reverse_relationships, foreign_key: 'follower_id',
           class_name: 'Relationship',
           dependent: :destroy
  has_many :followings, through: :reverse_relationships, source: :following

  # to declare associations for 'like' functionality
  has_many :likes, dependent: :destroy
  has_many :like_items, class_name: 'Item', through: :likes,
           source: :likeable, source_type: 'Item'

  # to declare associations for 'community' functionality
  has_many :associates
  has_many :communities, :through => :associates
  has_many :communities_owned_by_me, class_name: 'Community', 
           foreign_key: :owner_id

###############################################################################
##
##   Definitions of Method      
##
###############################################################################

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      logger.error "*"*20
      logger.error auth.info.image
      user.remote_avatar_url = auth.info.image
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.nickname
      user.email = auth.info.email
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end    
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
   
  # Associate-Community Model
  # Methods: join!, leave!
  def join!(community)
    associates.create!(community_id: community.id)
  end
  def leave!(community)
    associates.find_by(community_id: community.id).destroy!
  end

  # Like Model
  # Methods: like!, dislike!, liking?
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

  # Relationship Model
  # Methods: following?, follow!, unfollow!
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
