class Cms::PricingsController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  load_resource :through => :real_estate, :singleton => true
  authorize_resource :through => :real_estate, :singleton => true, :except => :show

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_pricing_path(@real_estate), :alert => exception.message
  end

  def new
  end

  def edit
  end

  def create
    if @pricing.save
      redirect_to_step(next_step_after('pricing'))
    else
      render 'new'
    end
  end

  def update
    if @pricing.update_attributes(params[:pricing])
      redirect_to_step(next_step_after('pricing'))
    else
      render 'edit'
    end
  end

  def show
  end

end
