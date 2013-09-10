module ApplicationHelper

  def pageless(total_pages, url=nil, container=nil)
    opts = {
        :totalPages  => total_pages,
        :url         => url,
        :loaderMsg   => 'Loading more pages...',
        :loaderImage => image_path('load1.gif')
    }

    container && opts[:container] ||= container

    javascript_tag("$('#items').pageless(#{opts.to_json});")
  end

  def list_of_likers(item)
    users = item.likers
    users_count = users.size
    emails_return = users[0..9].map {|user| "<i class='icon-user'></i> " + user.email}.join('<br />')
    if users_count > 11
      emails_return += "<br />#{(users_count - 10)} more..."
    end
    "<div style='text-align:left !important;'>#{emails_return}</div>"
  end


  # def markdown(text)
  #   markdown = Redcarpet::Markdown.new(PygmentsHTML, :gh_blockcode => true)
  #   markdown.render(text).html_safe
  # end
end
