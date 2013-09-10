# == Schema Information
#
# Table name: communities
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  owner_id    :integer
#  description :text
#

###############################################################################
#
#   Community Model Class      
#
###############################################################################

class Community < ActiveRecord::Base

  # Apply Authorization to Community Model (using Authority Gem) 
  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities

  self.authorizer_name = 'CommunityAuthorizer'

###############################################################################
##
##   Scopes of Model       
##
###############################################################################  

  default_scope -> {order(name: :asc)}

###############################################################################
##
##   Declaration of Model Assoications       
##
###############################################################################

	has_many :associates, dependent: :destroy
	has_many :members, class_name: 'User', :through => :associates
	#has_many :users, :through => :associates
  has_many :items, :through => :members
  #has_many :items, :through => :users
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  
###############################################################################
##
##   Model Validations       
##
###############################################################################

  validates :name, presence: true, uniqueness: true

end
