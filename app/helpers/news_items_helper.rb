module NewsItemsHelper

  def load_more_link current_offset
    link_to t('news_items.index.load_more'), 
            news_items_path(:offset => current_offset + NewsItem::PER_PAGE), 
            :remote => true
  end
end