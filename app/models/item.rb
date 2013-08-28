class Item < ActiveRecord::Base
  acts_as_taggable  
  belongs_to :user
  mount_uploader :photo, PhotoUploader

  attr_accessor :remote_avatar_url

  validates_presence_of :photo, :description, if: :check_remote_photo_url

  has_many :comments, as: :commentable, dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, through: :likes,  source: :user

  def check_remote_photo_url
    self.remote_photo_url.blank?
  end
end
