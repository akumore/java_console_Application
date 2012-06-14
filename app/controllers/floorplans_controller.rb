class FloorplansController < ApplicationController

  def index
    @real_estate = RealEstateDecorator.decorate RealEstate.find params[:real_estate_id]
    render :layout => 'simple'
  end

  def show
    @floor_plan = MediaAssets::FloorPlanDecorator.decorate RealEstate.find(params[:real_estate_id]).floor_plans.find(params[:id])
    render :layout => 'simple'
  end
end
