module ApplicationHelper

  def markdown string
    RDiscount.new(string).to_html.html_safe
  end

  def path_to_url(path)
      request.protocol + request.host_with_port + path
  end
end
