class NewsItemsController < ApplicationController

  def index
    @news_items = NewsItem.all.order([:date, :desc]).published

    respond_to do |format|
      format.html do
        filtered_news_items = @news_items.where(:date.gte => 3.years.ago.beginning_of_year)
        @news_items_by_year = filtered_news_items.group_by { |item| item.date.year.to_s }

        @year = params[:year]
        @year = filtered_news_items.max(:date).year.to_s unless @news_items_by_year.keys.include?(@year)

        @news_items = @news_items_by_year[@year]
      end

      format.xml do
        render layout: false
      end
    end
  end
end
