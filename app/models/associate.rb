# == Schema Information
#
# Table name: associates
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  community_id :integer
#  access_type  :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

###############################################################################
#
#   Associate Model Class      
#
#   : Join Model to connect User and Community models 
#     (Many-to-many association)
#
###############################################################################

class Associate < ActiveRecord::Base
  belongs_to :member, class_name: 'User', foreign_key: :user_id
  #belongs_to :user
  belongs_to :community

  # Callbacks
  before_save :default_values

###############################################################################
##
##   Definitions of Callback Method      
##
###############################################################################
   
  def default_values
  	self.access_type = 'member'
  end
end
