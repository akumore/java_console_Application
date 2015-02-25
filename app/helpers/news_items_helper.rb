module NewsItemsHelper

  def heyhey
    @news_items_by_year.keys.map { |year| [year] }
  end
end
