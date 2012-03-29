module Cms
  class NewsItemsController < Cms::SecuredController

    rescue_from Mongoid::Errors::DocumentNotFound do |err|
      flash[:warn] = "Gesuchter Newseintrag wirde nicht gefunden"
      redirect_to cms_news_items_path
    end


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
      @news_item=NewsItem.find params[:id]
      if @news_item.update_attributes(params[:news_item])
        #TODO flash success
        redirect_to [:edit, :cms, @news_item]
      else
        render 'edit'
      end
    end

  end
end