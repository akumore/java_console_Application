class Cms::PricingsController < Cms::SecuredController
  include EmbeddedInRealEstate

  def new
    @pricing = Pricing.new
    respond_with @pricing
  end

  def edit
    @pricing = @real_estate.pricing
  end

  def create
    @pricing = Pricing.new(params[:pricing])
    @pricing.real_estate = @real_estate

    if @pricing.save
      if @real_estate.figure.present?
        redirect_to edit_cms_real_estate_figure_path(@real_estate)
      else
        redirect_to new_cms_real_estate_figure_path(@real_estate)
      end
    else
      render 'new'
    end
  end

  def update
    @pricing = @real_estate.pricing

    if @pricing.update_attributes(params[:pricing])
      if @real_estate.figure.present?
        redirect_to edit_cms_real_estate_figure_path(@real_estate)
      else
        redirect_to new_cms_real_estate_figure_path(@real_estate)
      end
    else
      render 'edit'
    end
  end
end
