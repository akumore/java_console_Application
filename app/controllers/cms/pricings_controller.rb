class Cms::PricingsController < Cms::SecuredController
  include EmbeddedInRealEstate

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_pricing_path(@real_estate), :alert => exception.message
  end


  def new
    @pricing = Pricing.new
    respond_with @pricing
  end

  def edit
  end

  def create
    if @pricing.save
      redirect_to_step('figure')
    else
      render 'new'
    end
  end

  def update
    if @pricing.update_attributes(params[:pricing])
      redirect_to_step('figure')
    else
      render 'edit'
    end
  end
  
  def show
  end
  
end
