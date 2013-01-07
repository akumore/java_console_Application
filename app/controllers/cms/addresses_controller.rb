class Cms::AddressesController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  load_resource :through => :real_estate, :singleton => true
  authorize_resource :through => :real_estate, :singleton => true, :except => :show

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_address_path(@real_estate), :alert => exception.message
  end


  def new
    @address = Address.new
    respond_with @address
  end

  def edit
  end

  def create
    @address.real_estate = @real_estate

    if @address.save
      redirect_to_step(next_step_after('address'))
    else
      render 'new'
    end
  end

  def update
    if @address.update_attributes(params[:address])
      redirect_to_step(next_step_after('address'))
    else
      render 'edit'
    end
  end

  def show
  end

end
