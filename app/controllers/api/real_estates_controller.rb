module Api
  class RealEstatesController < ActionController::Base
    layout :false
    respond_to :json

    def index
      I18n.locale = :de

      if params[:microsite] == MicrositeBuildingProject::FELDPARK
        @real_estates = MicrositeDecorator.decorate RealEstate.microsite.feldpark.published.all
      elsif params[:microsite] == MicrositeBuildingProject::BUENZPARK
        @real_estates = MicrositeDecorator.decorate RealEstate.microsite.buenzpark.published.all
      else
        @real_estates = MicrositeDecorator.decorate RealEstate.microsite.gartenstadt.published.all
      end

      respond_with @real_estates.sort, :callback => params[:callback]
    end
  end
end
