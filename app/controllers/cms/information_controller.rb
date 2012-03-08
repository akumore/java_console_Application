class Cms::InformationController < Cms::SecuredController
  include EmbeddedInRealEstate

  def new
    @information = Information.new
    @information.real_estate = @real_estate
  end

  def edit
    @information = @real_estate.information
  end

  def create
    @information = Information.new(params[:information])
    @information.real_estate = @real_estate

    if @information.save
      if @real_estate.pricing.present?
        redirect_to edit_cms_real_estate_pricing_path(@real_estate)
      else
        redirect_to new_cms_real_estate_pricing_path(@real_estate)
      end
    else
      render 'new'
    end
  end

  def update
    @information = @real_estate.information

    if @information.update_attributes(params[:information])
      if @real_estate.pricing.present?
        redirect_to edit_cms_real_estate_pricing_path(@real_estate)
      else
        redirect_to new_cms_real_estate_pricing_path(@real_estate)
      end
    else
      render 'edit'
    end    
  end
end
