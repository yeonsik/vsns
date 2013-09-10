module CommunitiesHelper
  def markup_community(community)
    if current_user.communities.exists? community
      content_tag(:li, id: "community_#{community.id}") do
        link_to(community.name, community) +
        link_to(raw("<i class='icon-signout'></i>"), leave_community_path(community), method: :delete, data:{confirm:'Are your sure?'}, remote: true, class:'one_community', rel:'tooltip', title:'leave')
      end     
    else
      content_tag(:li, id: "community_#{community.id}") do
        (community.name + 
                link_to(raw("<i class='icon-signin'></i>"), join_community_path(community), method: :post, remote: true, class:'one_community', rel:'tooltip', title:'join')).html_safe
      end
    end
  end
end
