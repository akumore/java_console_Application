class FloorplansController < ApplicationController

  def index
    @real_estate = RealEstateDecorator.decorate RealEstate.find params[:real_estate_id]
    render :layout => 'print'
  end
end
