# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  likeable_id   :integer
#  likeable_type :string(255)
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

###############################################################################
#
#   Like Model Class      
#
###############################################################################

class Like < ActiveRecord::Base

###############################################################################
##
##   Declaration of Model Assoications       
##
##   : Join Model to connect User and polymophic :likeable model
##
###############################################################################

  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :liker, class_name: 'User', foreign_key: :user_id
  #belongs_to :user

end
