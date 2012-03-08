class Cms::AddressesController < Cms::SecuredController
  include EmbeddedInRealEstate

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
end
