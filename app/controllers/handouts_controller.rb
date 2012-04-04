class HandoutsController < ApplicationController
  layout 'handout'
  
  def show
    @real_estate = RealEstate.find(params[:id])
  end
end