class RealEstatesController < ApplicationController

  before_filter :set_search_filter

  def index
    @real_estates = get_filtered_real_estates(@search_filter)
  end


  private
  def set_search_filter
    @search_filter = SearchFilter.new :offer=>params[:offer], :utilization=>params[:utilization]
  end

  def get_filtered_real_estates(search_filter)
    RealEstate.where(search_filter.to_h).all
  end

end
