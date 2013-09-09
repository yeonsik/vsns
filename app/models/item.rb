# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  photo        :string(255)
#  url_ref      :string(255)
#  description  :text(255)
#  starts_count :integer          default(0)
#  created_at   :datetime
#  updated_at   :datetime
#  likes_count  :integer          default(0)
#

###############################################################################
#
#   Item Model Class      
#
#   : Core Model in VSNS
#
###############################################################################

class Item < ActiveRecord::Base

  attr_accessor :remote_avatar_url
  
  # Apply Authorization to Item Model (using Authority Gem) 
  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities

  # Taggable module method, calls acts_as_taggable_on :tags 
  acts_as_taggable

  # :photo attrbute connect to Carrierwave Uploader
  mount_uploader :photo, PhotoUploader

###############################################################################
##
##   Declaration of Model Assoications       
##
###############################################################################

  # Rolify Module method : has_many :roles 
  resourcify

  belongs_to :user
  
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, class_name: 'User', foreign_key: :user_id, through: :likes,  source: :liker

###############################################################################
##
##   Model Validations       
##
###############################################################################

  validates_presence_of :photo, :description, if: :check_remote_photo_url

###############################################################################
##
##   Definitions of Method       
##
###############################################################################

  def check_remote_photo_url
    self.remote_photo_url.blank?
  end
end
