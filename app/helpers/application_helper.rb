module ApplicationHelper

  def markdown string
    RDiscount.new(string).to_html.html_safe
  end

  def path_to_url(path)
      request.protocol + request.host_with_port + path
  end

  def footer_news_item_link(news_item)
    if request.path == news_items_path
      link_to t(".get_more"), news_items_path(:anchor => "news_item_#{news_item.id}"), :onclick => "$('#news_item_#{news_item.id} .title').click(); return false"
    else
      link_to t(".get_more"), news_items_path(:anchor => "news_item_#{news_item.id}")
    end
  end

end
