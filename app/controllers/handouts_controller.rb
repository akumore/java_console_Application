class HandoutsController < ApplicationController
  layout 'handout'

  def show
    @real_estate = RealEstate.find(params[:real_estate_id])
  end

  def footer
    render :layout => false
  end
end