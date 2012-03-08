class Cms::DescriptionsController < Cms::SecuredController
  include EmbeddedInRealEstate

  def new
    @description = Description.new
    respond_with @description
  end

  def edit
    @description = @real_estate.descriptions
    respond_with @description
  end

  def create
    @description = Description.new(params[:description])
    @description.real_estate = @real_estate

    if @description.save
      flash[:success] = success_message_for(controller_name)
      redirect_to cms_real_estate_media_assets_path(@real_estate)
    else
      render 'new'
    end
  end

  def update
    @description = @real_estate.descriptions

    if @description.update_attributes(params[:description])
      flash[:success] = success_message_for(controller_name)
      redirect_to cms_real_estate_media_assets_path(@real_estate)
    else
      render 'edit'
    end
  end
end
