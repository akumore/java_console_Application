module Cms
  class NewsItemsController < Cms::SecuredController

    rescue_from Mongoid::Errors::DocumentNotFound do |err|
      flash[:warn] = "Gesuchter Newseintrag wirde nicht gefunden"
      redirect_to cms_news_items_path
    end

    def index
      @news_items = NewsItem.all.where(:locale => content_locale).order([:date, :desc])
    end

    def new
      @news_item = NewsItem.new(:locale => params[:content_locale])
      build_images_and_documents!(@news_item)
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
        build_images_and_documents!(@news_item)
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

    def destroy
      @news_item=NewsItem.find params[:id]
      if @news_item.destroy
        flash[:info] = t("cms.news_items.destroy.success")
      end
      redirect_to cms_news_items_path
    end


    private
    def build_images_and_documents!(news_item)
      min_number_of_elements = 2
      min_number_of_elements.times do
        news_item.images.build if news_item.images.size < min_number_of_elements
        news_item.documents.build if news_item.documents.size < min_number_of_elements
      end
      news_item
    end

  end
end