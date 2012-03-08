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
      redirect_to_step('figure')
    else
      render 'new'
    end
  end

  def update
    @pricing = @real_estate.pricing

    if @pricing.update_attributes(params[:pricing])
      redirect_to_step('figure')
    else
      render 'edit'
    end
  end
end
