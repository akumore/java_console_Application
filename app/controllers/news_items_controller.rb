class NewsItemsController < ApplicationController

  respond_to :html, :js

  def index
    @offset = params[:offset].presence.to_i
    @news_items = NewsItem.all
                    .where(:locale => I18n.locale)
                    .order([:date, :desc])
                    .skip(@offset)
                    .limit(NewsItem::PER_PAGE)
  end
end