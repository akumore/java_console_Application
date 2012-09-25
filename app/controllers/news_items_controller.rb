class NewsItemsController < ApplicationController

  def index
    @offset = params[:offset].presence.to_i
    @news_items = NewsItem.where(:locale => I18n.locale).order([:date, :desc]).skip(@offset)

    respond_to do |format|
      format.html { @news_items = @news_items.limit(NewsItem::PER_PAGE) }
      format.js   { @news_items = @news_items.limit(NewsItem::PER_PAGE) }
      format.xml  { render :layout => false }
    end
  end
end
