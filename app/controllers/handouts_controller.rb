class HandoutsController < ApplicationController
  layout 'handout'

  caches_page :footer

  def show
    @real_estate = RealEstate.find(params[:real_estate_id])
  end

  def footer
    render :layout => false
  end
end