class RealEstatesController < ApplicationController
  
  respond_to :html

  def index
    @real_estates = RealEstate.all
  end

  def show
    @real_estate = RealEstateDecorator.find(params[:id])
  end

end
