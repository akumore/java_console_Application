module ApplicationHelper

  def markdown string
    RDiscount.new(string).to_html.html_safe
  end

end