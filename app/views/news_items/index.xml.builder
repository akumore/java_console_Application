# encoding: utf-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Alfred Müller RSS Feed"
    xml.description "Alfred Müller News"
    xml.link "http://www.alfred-mueller.ch"

    @news_items.each do |news_item|
      xml.item do
        xml.title news_item.title
        xml.description RDiscount.new(news_item.content).to_html.html_safe
        xml.pubDate news_item.date.to_s(:rfc822)
        xml.link "http://#{request.env["HTTP_HOST"]}/#{I18n.locale}/news_items#news_item_#{news_item.id}"
        xml.guid news_item.id
      end
    end
  end
end

