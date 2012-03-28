module Cms
  class NewsItemsController < Cms::SecuredController

    def index
    end

    def new
      @news_item = NewsItem.new(:locale => params[:locale] || :de)
    end

    def edit
      @news_item=NewsItem.find params[:id]
    end

    def create
      @news_item = NewsItem.new params[:news_item]
      if @news_item.save
        #TODO flash success
        redirect_to [:edit, :cms, @news_item]
      else
        render 'new'
      end
    end

    def update
      #TODO
    end

  end
end