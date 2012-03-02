class RealEstatesController < ApplicationController

  respond_to :html

  rescue_from Mongoid::Errors::DocumentNotFound do
    redirect_to real_estates_path
  end

  before_filter :set_search_filter

  def index
    @real_estates = get_filtered_real_estates(@search_filter)
    @reference_projects = RealEstateDecorator.decorate get_filtered_reference_projects(@search_filter)
  end

  def show
    @real_estate = RealEstateDecorator.decorate RealEstate.published.web_channel.find(params[:id])
    real_estates = get_filtered_real_estates(@search_filter).map(&:id)
    @prev_real_estate = real_estates[real_estates.index(@real_estate.id) - 1] rescue real_estates.last
    @next_real_estate = real_estates[real_estates.index(@real_estate.id) + 1] rescue real_estates.first
    @appointment = @real_estate.appointments.build
  end

  private

  def set_search_filter
    @search_filter = SearchFilter.new :offer => params[:offer], :utilization => params[:utilization]
  end

  def get_filtered_real_estates(search_filter)
    RealEstate.published.web_channel.where(search_filter.to_h)
  end

  def get_filtered_reference_projects search_filter
    offer = search_filter.for_sale? ? RealEstate::OFFER_FOR_SALE : RealEstate::OFFER_FOR_RENT
    RealEstate.published.web_channel.reference_projects.where(:offer => offer)
  end
end
