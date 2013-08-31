class Associate < ActiveRecord::Base
  belongs_to :user
  belongs_to :community

  before_save :default_values

  def default_values
  	unless self.access_type.nil?
  		self.access_type = "member"
  	end
  end
end
