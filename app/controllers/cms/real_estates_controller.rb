class Cms::RealEstatesController < Cms::SecuredController
  # GET /cms/real_estates
  # GET /cms/real_estates.json
  def index
    @real_estates = RealEstate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @real_estates }
    end
  end

  # GET /cms/real_estates/1
  # GET /cms/real_estates/1.json
  def show
    @real_estate = RealEstate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @real_estate }
    end
  end

  # GET /cms/real_estates/new
  # GET /cms/real_estates/new.json
  def new
    @real_estate = RealEstate.new(:reference => Reference.new)
  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @real_estate }
    end
  end

  # GET /cms/real_estates/1/edit
  def edit
    @real_estate = RealEstate.find(params[:id])
  end

  # POST /cms/real_estates
  # POST /cms/real_estates.json
  def create
    @real_estate = RealEstate.new(params[:real_estate])

    respond_to do |format|
      if @real_estate.save
        format.html { redirect_to edit_cms_real_estate_path(@real_estate) }
        format.json { render :json => @real_estate, :status => :created, :location => @real_estate }
      else
        format.html { render :action => "new" }
        format.json { render :json => @real_estate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cms/real_estates/1
  # PUT /cms/real_estates/1.json
  def update
    @real_estate = RealEstate.find(params[:id])
    new_state = params[:real_estate].delete(:next_state)

    respond_to do |format|
      if @real_estate.update_attributes(params[:real_estate])
        switch_state!(new_state) if new_state
        format.html { redirect_to edit_cms_real_estate_path(@real_estate) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @real_estate.errors, :status => :unprocessable_entity }
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


  private
  def switch_state!(new_state)
    event = {:editing => :edit!, :in_review => :review!, :published => :publish!}[new_state.to_sym]
    @real_estate.send(event) if new_state.to_sym == next_state(@real_estate)
  end

end
