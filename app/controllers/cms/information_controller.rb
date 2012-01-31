class Cms::InformationController < Cms::SecuredController

  respond_to :html, :json

  def new
    @real_estate = RealEstate.find params[:real_estate_id]
    @information = Information.new
  end

  def edit
    @real_estate = RealEstate.find params[:real_estate_id]
    @information = @real_estate.information
  end

  def create
    @real_estate = RealEstate.find params[:real_estate_id]
    @information = Information.create params[:information].merge(:real_estate=>@real_estate)

    respond_with @information, :location=> edit_cms_real_estate_information_path(@real_estate)
  end

  def update
    @real_estate = RealEstate.find params[:real_estate_id]
    @information = @real_estate.information

    @information.update_attributes params[:information]
    respond_with @information, :location=> edit_cms_real_estate_information_path(@real_estate)
  end

end
