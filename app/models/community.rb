class Community < ActiveRecord::Base

  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities

  self.authorizer_name = 'CommunityAuthorizer'
  default_scope -> {order(name: :asc)}

	has_many :associates, dependent: :destroy
	has_many :users, :through => :associates
  has_many :items, :through => :users
  belongs_to :owner, class_name: 'User'
  
  validates :name, presence: true, uniqueness: true
end
