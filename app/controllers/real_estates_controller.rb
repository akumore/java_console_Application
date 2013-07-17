require 'real_estate_pagination'

class RealEstatesController < ApplicationController
  respond_to :html

  rescue_from Mongoid::Errors::DocumentNotFound do
    redirect_to real_estates_path
  end

  before_filter :set_search_filter

  def index
    @real_estates = RealEstateDecorator.decorate get_filtered_real_estates(@search_filter)
    @filtered_offer_utilization_real_estates = get_filtered_offer_utilization_real_estates(@search_filter)
    @reference_projects = ReferenceProjectDecorator.decorate get_filtered_reference_projects(@search_filter)
  end

  def show
    @real_estate = RealEstateDecorator.decorate RealEstate.published.web_channel.find(params[:id])
    @search_filter.utilization = @real_estate.utilization
    @search_filter.offer = @real_estate.offer
    real_estates = get_filtered_real_estates(@search_filter).map(&:id)
    @pagination = RealEstatePagination.new(@real_estate, real_estates)
    @appointment = @real_estate.appointments.build
    @filtered_offer_utilization_real_estates = get_filtered_offer_utilization_real_estates(@search_filter)

    log_event("#{t("real_estates.search_filter.#{@real_estate.offer}")} #{t("real_estates.search_filter.#{@real_estate.utilization}")}", 'Ansicht Immobilie', @real_estate.address.simple)
  end

  private

  def set_search_filter
    filter_params = (params[:search_filter] || {}).reverse_merge(:offer => params[:offer], :utilization => params[:utilization],
                                                                 :cantons => params[:cantons], :cities => params[:cities],
                                                                 :sort_order => params[:sort_order], :sort_field => params[:sort_field])
    @search_filter = Search::Filter.new(filter_params)
  end

  def get_filtered_real_estates(search_filter)
    RealEstate.published.web_channel.where(search_filter.to_query_hash).order_by(@search_filter.to_query_order_array).all
  end

  def get_filtered_offer_utilization_real_estates(search_filter)
    RealEstate.published.web_channel.where(:offer => search_filter.offer, :utilization => search_filter.utilization)
  end

  def get_filtered_reference_projects(search_filter)
    offer = search_filter.for_sale? ? Offer::SALE : Offer::RENT
    utilization = search_filter.commercial? ? Utilization::WORKING : Utilization::LIVING
    ReferenceProject.where(:locale => I18n.locale, :offer => offer, :utilization => utilization, :displayed_on => ReferenceProject::HOME_AND_OFFER_PAGE)
  end
end
