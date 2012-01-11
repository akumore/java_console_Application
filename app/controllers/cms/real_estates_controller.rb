class Cms::RealEstatesController < Cms::SecuredController
  # GET /cms/real_estates
  # GET /cms/real_estates.json
  def index
    @real_estates = RealEstate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @real_estates }
    end
  end

  # GET /cms/real_estates/1
  # GET /cms/real_estates/1.json
  def show
    @real_estate = RealEstate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @real_estate }
    end
  end

  # GET /cms/real_estates/new
  # GET /cms/real_estates/new.json
  def new
    @real_estate = RealEstate.new(
      :reference => Reference.new, 
      :utilization => RealEstate::UTILIZATION_PRIVATE,
      :offer => RealEstate::OFFER_FOR_RENT,
      :channels => [RealEstate::CHANNELS.first]
    )
  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @real_estate }
    end
  end

  # GET /cms/real_estates/1/edit
  def edit
    @real_estate = RealEstate.find(params[:id])
  end

  # POST /cms/real_estates
  # POST /cms/real_estates.json
  def create
    @real_estate = RealEstate.new(params[:cms_real_estate])

    respond_to do |format|
      if @real_estate.save
        format.html { redirect_to @real_estate, notice: 'Real estate was successfully created.' }
        format.json { render json: @real_estate, status: :created, location: @real_estate }
      else
        format.html { render action: "new" }
        format.json { render json: @real_estate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cms/real_estates/1
  # PUT /cms/real_estates/1.json
  def update
    @real_estate = RealEstate.find(params[:id])

    respond_to do |format|
      if @real_estate.update_attributes(params[:cms_real_estate])
        format.html { redirect_to @real_estate, notice: 'Real estate was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @real_estate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cms/real_estates/1
  # DELETE /cms/real_estates/1.json
  def destroy
    @real_estate = RealEstate.find(params[:id])
    @real_estate.destroy

    respond_to do |format|
      format.html { redirect_to cms_real_estates_url }
      format.json { head :ok }
    end
  end
end
