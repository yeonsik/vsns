class Item < ActiveRecord::Base

  acts_as_taggable  
  belongs_to :user
  mount_uploader :photo, PhotoUploader

  validates_presence_of :photo, :description
end
