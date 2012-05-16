class FloorplansController < ApplicationController

  def index
    @real_estate = RealEstate.find params[:real_estate_id]
    render :layout => nil
  end
end
