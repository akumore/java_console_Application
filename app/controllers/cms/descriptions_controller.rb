class Cms::DescriptionsController < Cms::SecuredController
  include EmbeddedInRealEstate

  def new
    @description = Description.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @description }
    end
  end

  def edit
    @description = @real_estate.descriptions
  end

  def create
    @description = Description.new(params[:description])
    @description.real_estate = @real_estate

    respond_to do |format|
      if @description.save
        format.html { redirect_to edit_cms_real_estate_description_path(@real_estate) }
        format.json { render :json => @description, :status => :created, :location => @description }
      else
        format.html { render :action => "new" }
        format.json { render :json => @description.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @description = @real_estate.descriptions

    respond_to do |format|
      if @description.update_attributes(params[:description])
        format.html { redirect_to edit_cms_real_estate_description_path(@real_estate) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @description.errors, :status => :unprocessable_entity }
      end
    end
  end
end
