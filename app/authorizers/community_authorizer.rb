class CommunityAuthorizer < ApplicationAuthorizer

  # To update a specific resource instance, you must either own it or be an admin
  def updatable_by?(user)
    resource.owner == user || user.has_role?(:admin)
  end

  def deletable_by?(user)
    resource.owner == user || user.has_role?(:admin)
  end

end
