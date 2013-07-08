module Api
  class RealEstatesController < ActionController::Base
    layout :false
    respond_to :json

    def index
      I18n.with_locale :de do
        microsite = params[:microsite] || MicrositeBuildingProject::GARTENSTADT
        @real_estates = MicrositeDecorator.decorate(
          RealEstate.named_microsite(microsite).published
        )
        respond_with @real_estates.sort, :callback => params[:callback]
      end
    end
  end
end
