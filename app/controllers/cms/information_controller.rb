class Cms::InformationController < Cms::SecuredController

  def new
    @real_estate = RealEstate.find params[:real_estate_id]
    @information = Information.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @information }
    end
  end

  #def edit
  #  @information = Information.find(params[:id])
  #end

  #def create
  #  @information = Information.new(params[:information])
  #
  #  respond_to do |format|
  #    if @information.save
  #      format.html { redirect_to @information, notice: 'Information was successfully created.' }
  #      format.json { render json: @information, status: :created, location: @information }
  #    else
  #      format.html { render action: "new" }
  #      format.json { render json: @information.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # PUT /information/1
  # PUT /information/1.json
  #def update
  #  @information = Information.find(params[:id])
  #
  #  respond_to do |format|
  #    if @information.update_attributes(params[:information])
  #      format.html { redirect_to @information, notice: 'Information was successfully updated.' }
  #      format.json { head :ok }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @information.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

end
