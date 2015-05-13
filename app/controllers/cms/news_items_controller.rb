module Cms
  class NewsItemsController < Cms::SecuredController
    authorize_resource
    before_filter :fetch_news_item, only: [:edit, :update, :destroy]

    rescue_from CanCan::AccessDenied do |err|
      redirect_to cms_dashboards_path, alert: err.message
    end

    rescue_from Mongoid::Errors::DocumentNotFound do |err|
      flash[:warn] = "Gesuchter Newseintrag wurde nicht gefunden"
      redirect_to cms_news_items_path
    end

    def index
      @news_items = NewsItem.all.order([:date, :desc])
    end

    def new
      @news_item = NewsItem.new(locale: content_locale)
      build_images_and_documents!(@news_item)
    end

    def edit
    end

    def create
      I18n.with_locale(content_locale) do
        @news_item = NewsItem.new params[:news_item]
        success = @news_item.save
      end

      if success
        flash[:success] = t("cms.news_items.create.success")
        redirect_to cms_news_items_path(content_locale: content_locale)
      else
        build_images_and_documents!(@news_item)
        render 'new'
      end
    end

    def update
      success = I18n.with_locale(content_locale) { @news_item.update_attributes(params[:news_item]) }

      if success
        flash[:success] = t("cms.news_items.update.success")
        redirect_to cms_news_items_path(content_locale: content_locale)
      else
        render 'edit'
      end
    end

    def destroy
      if @news_item.destroy
        flash[:success] = t("cms.news_items.destroy.success")
      end
      redirect_to cms_news_items_path(content_locale: content_locale)
    end

    private

    def fetch_news_item
      @news_item = NewsItem.find(params[:id])
    end

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
