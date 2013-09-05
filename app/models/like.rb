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
