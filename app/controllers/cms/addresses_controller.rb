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
      if @real_estate.information.present?
        redirect_to edit_cms_real_estate_information_path(@real_estate)
      else
        redirect_to new_cms_real_estate_information_path(@real_estate)
      end
    else
      render 'new'
    end
  end

  def update
    @address = @real_estate.address

    if @address.update_attributes(params[:address])
      if @real_estate.information.present?
        redirect_to edit_cms_real_estate_information_path(@real_estate)
      else
        redirect_to new_cms_real_estate_information_path(@real_estate)
      end
    else
      render 'edit'
    end    
  end
end
