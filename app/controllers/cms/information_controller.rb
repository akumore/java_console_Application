class Cms::InformationController < Cms::SecuredController
  include EmbeddedInRealEstate

  def new
    @information = Information.new
  end

  def edit
    @information = @real_estate.information
  end

  def create
    @information = Information.create params[:information].merge(:real_estate=>@real_estate)
    respond_with @information, :location=> edit_cms_real_estate_information_path(@real_estate)
  end

  def update
    @information = @real_estate.information
    @information.update_attributes params[:information]
    respond_with @information, :location=> edit_cms_real_estate_information_path(@real_estate)
  end
end
