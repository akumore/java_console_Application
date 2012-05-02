module Api
  class RealEstatesController < ActionController::Base
    layout :false
    respond_to :json

    def index
      @real_estates = RealEstate.limit(1).all #microsite.published
      respond_with @real_estates, :callback=>params[:callback]
    end

  end
end