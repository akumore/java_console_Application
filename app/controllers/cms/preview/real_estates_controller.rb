class Cms::Preview::RealEstatesController < RealEstatesController
  protect_from_forgery
  before_filter :authenticate_user!

  def show
    @real_estate = RealEstateDecorator.decorate RealEstate.find(params[:id])
    @search_filter.utilization = @real_estate.utilization
    @search_filter.offer = @real_estate.offer
    real_estates = get_filtered_real_estates(@search_filter).map(&:id)
    @pagination = RealEstatePagination.new(@real_estate, real_estates)
    @appointment = @real_estate.appointments.build
    @real_estates = RealEstateDecorator.decorate get_filtered_real_estates(@search_filter)
  end
end

