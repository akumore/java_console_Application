module Api
  class RealEstatesController < ActionController::Base
    layout :false
    respond_to :json

    def index
      I18n.locale = :de
      @real_estates = MicrositeDecorator.decorate RealEstate.microsite.published.all
      respond_with @real_estates.sort, :callback=>params[:callback]
    end

  end
end
