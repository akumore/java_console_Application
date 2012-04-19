class HandoutsController < ApplicationController
  layout 'handout'

  caches_page :footer

  def show
    @real_estate = RealEstate.published.print_channel.find(params[:real_estate_id])
    raise 'Real Estate must be for rent' if @real_estate.for_sale?
  end

  def footer
    render :layout => false
  end
end
