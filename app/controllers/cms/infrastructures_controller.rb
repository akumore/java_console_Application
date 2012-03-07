class Cms::InfrastructuresController < Cms::SecuredController
  include EmbeddedInRealEstate

  def new
    @infrastructure = Infrastructure.new
    @infrastructure.build_all_points_of_interest

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @infrastructure }
    end
  end

  def edit
    @infrastructure = @real_estate.infrastructure
    @infrastructure.build_all_points_of_interest
  end

  def create
    @infrastructure = Infrastructure.new(params[:infrastructure])
    @infrastructure.real_estate = @real_estate

    respond_to do |format|
      if @infrastructure.save
        format.html { redirect_to edit_cms_real_estate_infrastructure_path(@real_estate) }
        format.json { render :json => @infrastructure, :status => :created, :location => @infrastructure }
      else
        format.html { render :action => "new" }
        format.json { render :json => @infrastructure.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @infrastructure = @real_estate.infrastructure

    respond_to do |format|
      if @infrastructure.update_attributes(params[:infrastructure])
        format.html { redirect_to edit_cms_real_estate_infrastructure_path(@real_estate) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @infrastructure.errors, :status => :unprocessable_entity }
      end
    end
  end
end
