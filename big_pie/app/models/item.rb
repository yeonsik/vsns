class Item < ActiveRecord::Base
  belongs_to :user
  mount_uploader :photo, PhotoUploader

  validates_presence_of :photo, :description
end
