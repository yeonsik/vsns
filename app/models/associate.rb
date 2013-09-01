class Associate < ActiveRecord::Base
  belongs_to :user
  belongs_to :community

  before_save :default_values

  def default_values
  	self.access_type = "member"
  end
end
