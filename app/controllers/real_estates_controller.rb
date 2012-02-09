class RealEstatesController < ApplicationController

  respond_to :html

  before_filter :set_search_filter

  def index
    @real_estates = get_filtered_real_estates(@search_filter)
  end

  def show
    @real_estate = RealEstateDecorator.find(params[:id])
    real_estates = get_filtered_real_estates(@search_filter).map(&:id)
    @prev_real_estate = real_estates[real_estates.index(@real_estate.id) - 1] rescue real_estates.last
    @next_real_estate = real_estates[real_estates.index(@real_estate.id) + 1] rescue real_estates.first
  end

  private

  def set_search_filter
    @search_filter = SearchFilter.new :offer=>params[:offer], :utilization=>params[:utilization]
  end

  def get_filtered_real_estates(search_filter)
    RealEstate.where(search_filter.to_h)
  end
end
