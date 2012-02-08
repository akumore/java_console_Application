class RealEstatesController < ApplicationController
  
  respond_to :html

  before_filter :set_search_filter

  def index
    @real_estates = get_filtered_real_estates(@search_filter)
  end

  def show
    @real_estate = RealEstateDecorator.find(params[:id])
  end

  private
  def set_search_filter
    @search_filter = SearchFilter.new :offer=>params[:offer], :utilization=>params[:utilization]
  end

  def get_filtered_real_estates(search_filter)
    RealEstate.where(search_filter.to_h).all
  end
end
