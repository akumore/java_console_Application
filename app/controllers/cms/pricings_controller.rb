class Cms::PricingsController < Cms::SecuredController

  before_filter :load_real_estate

  def new
    @pricing = Pricing.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pricing }
    end
  end

  def edit
    @pricing = @real_estate.pricing
  end

  def create
    @pricing = Pricing.new(params[:pricing])
    @pricing.real_estate = @real_estate

    respond_to do |format|
      if @pricing.save
        format.html { redirect_to edit_cms_real_estate_pricing_path(@real_estate) }
        format.json { render :json => @pricing, :status => :created, :location => @pricing }
      else
        format.html { render :action => "new" }
        format.json { render :json => @pricing.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @pricing = @real_estate.pricing

    respond_to do |format|
      if @pricing.update_attributes(params[:pricing])
        format.html { redirect_to edit_cms_real_estate_pricing_path(@real_estate) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @pricing.errors, :status => :unprocessable_entity }
      end
    end
  end

protected
  
  def load_real_estate
    @real_estate = RealEstate.find(params[:real_estate_id])    
  end
end
