class Cms::RealEstatesController < Cms::SecuredController
  load_and_authorize_resource :except => [:index, :show]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to [:cms, @real_estate], :alert => exception.message
  end
  
  
  def index
    @real_estates = RealEstate.all
    respond_with @real_estates
  end

  def show
    @real_estate = RealEstate.find(params[:id])
    respond_with @real_estate
  end

  def new
    @real_estate = RealEstate.new(:reference => Reference.new)
    respond_with @real_estate
  end

  def edit
  end

  def create
    @real_estate = RealEstate.new(params[:real_estate])

    if @real_estate.save
      redirect_to new_cms_real_estate_address_path(@real_estate)
    else
      render 'new'
    end
  end

  def update
    if @real_estate.update_attributes(params[:real_estate])
      if @real_estate.published? || @real_estate.in_review? && cannot?(:publish_it, @real_estate)
        redirect_to [:cms, @real_estate]
      else
        if @real_estate.address.present?
          redirect_to edit_cms_real_estate_address_path(@real_estate)
        else
          redirect_to new_cms_real_estate_address_path(@real_estate)
        end
      end
    else
      render 'edit'
    end
  end

  def destroy
    @real_estate = RealEstate.find(params[:id])
    @real_estate.destroy
    redirect_to cms_real_estates_url
  end

end
