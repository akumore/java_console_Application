class Cms::AddressesController < Cms::SecuredController
  include EmbeddedInRealEstate

  authorize_resource :only => [:edit, :update], :through=>:real_estate

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_address_path(@real_estate), :alert => exception.message
  end


  def new
    @address = Address.new
    respond_with @address
  end

  def edit
    @address = @real_estate.address
  end

  def create
    @address = Address.new(params[:address])
    @address.real_estate = @real_estate

    if @address.save
      redirect_to_step('information')
    else
      render 'new'
    end
  end

  def update
    @address = @real_estate.address

    if @address.update_attributes(params[:address])
      redirect_to_step('information')
    else
      render 'edit'
    end    
  end
  
  def show
    @address = @real_estate.address
  end
  
end
