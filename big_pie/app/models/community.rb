class Community < ActiveRecord::Base
	has_many :associates
	has_many :users, :through => :associates
end
