class NewsItemsController < ApplicationController

  respond_to do |format|
    format.html
    format.js
    format.xml { render :layout => false }
  end

  def index
    @offset = params[:offset].presence.to_i
    @news_items = NewsItem.where(:locale => I18n.locale)
                          .order([:date, :desc])
                          .skip(@offset)
                          .limit(NewsItem::PER_PAGE)

    @feed_news_items = NewsItem.where(:locale => I18n.locale)
                               .order([:date, :desc])
                               .limit(20)
  end
end
