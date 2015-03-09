require 'real_estate_pagination'
require 'google_analytics_category_translator'

class RealEstatesController < ApplicationController
  respond_to :html
  include GoogleAnalyticsCategoryTranslator
  include RealEstatesHelper

  rescue_from Mongoid::Errors::DocumentNotFound do
    redirect_to real_estates_path
  end

  before_filter :set_search_filter

  def index
    @real_estates = RealEstateDecorator.decorate get_filtered_real_estates(@search_filter)
    @filtered_offer_utilization_real_estates = get_filtered_offer_utilization_real_estates(@search_filter)
    @reference_projects = ReferenceProjectDecorator.decorate get_filtered_reference_projects(@search_filter)
    @page = Page.where(cms_page_params).first or raise Mongoid::Errors::DocumentNotFound.new(Page, cms_page_params)
  end

  def show
    if user_signed_in? || local_request?
      @real_estate = accessible_real_estates.find(params[:id])
    else
      @real_estate = accessible_real_estates.web_channel.find(params[:id])
    end
    @real_estate = RealEstateDecorator.decorate(@real_estate)
    @search_filter.utilization = @real_estate.utilization
    @search_filter.offer = @real_estate.offer
    real_estates = get_filtered_real_estates(@search_filter).map(&:id)
    @pagination = RealEstatePagination.new(@real_estate, real_estates)
    @appointment = @real_estate.appointments.build
    @handout_order = HandoutOrder.new
    @filtered_offer_utilization_real_estates = get_filtered_offer_utilization_real_estates(@search_filter)

    log_event(translate_category(@real_estate), 'Ansicht Immobilie', @real_estate.address.simple)
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

  def cms_page_params
    { name: params[:controller], locale: params[:locale] }
  end
end
