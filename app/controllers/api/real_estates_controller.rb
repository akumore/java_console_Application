module Api
  class RealEstatesController < ActionController::Base
    layout :false
    respond_to :json

    def index
      @real_estates = MicrositeDecorator.decorate RealEstate.microsite.published.all
      respond_with @real_estates, :callback=>params[:callback]
    end

  end
end
