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

end
