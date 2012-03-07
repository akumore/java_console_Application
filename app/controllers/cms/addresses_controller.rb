class Cms::AddressesController < Cms::SecuredController
  include EmbeddedInRealEstate

  def new
    @address = Address.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @address }
    end
  end

  def edit
    @address = @real_estate.address
  end

  def create
    @address = Address.new(params[:address])
    @address.real_estate = @real_estate

    respond_to do |format|
      if @address.save
        format.html { redirect_to edit_cms_real_estate_address_path(@real_estate) }
        format.json { render :json => @address, :status => :created, :location => @address }
      else
        format.html { render :action => "new" }
        format.json { render :json => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @address = @real_estate.address

    respond_to do |format|
      if @address.update_attributes(params[:address])
        format.html { redirect_to edit_cms_real_estate_address_path(@real_estate) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @address.errors, :status => :unprocessable_entity }
      end
    end
  end
end
