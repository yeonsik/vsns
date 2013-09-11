# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  username               :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  avatar                 :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#

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
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

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


  # Class methods
  # -------------
  def self.from_omniauth(auth, signed_in_resource=nil)
    find_or_create_by(provider: auth[:provider], uid: auth[:uid]) do |user|
      user.provider           = auth.provider
      user.uid                = auth.uid
      user.email              = auth.info.email
      user.username           = auth.info.nickname
      user.remote_avatar_url  = auth.info.image
      user.password           = Devise.friendly_token[0, 20]
    end
  end

  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes']) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

###############################################################################
##
##   Definitions of Method      
##
###############################################################################

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

  def owned_my_tag_counts
    # items.tag_counts 은 Rails 4 의 relation 상에서 오류가남
    # acts_as_taggable_on 이 업데이트 되기 전까지 다음과 같이 사용
    Item.where(user_id: self.id).tag_counts
  end

end
