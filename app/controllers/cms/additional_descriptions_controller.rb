class Cms::AdditionalDescriptionsController < Cms::SecuredController
  include EmbeddedInRealEstate

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_additional_description_path(@real_estate), :alert => exception.message
  end


  def new
    @additional_description = AdditionalDescription.new
    respond_with @additional_description
  end

  def edit
    respond_with @additional_description
  end

  def create
    if @additional_description.save
      flash[:success] = success_message_for(controller_name)
      redirect_to cms_real_estate_media_assets_path(@real_estate)
    else
      render 'new'
    end
  end

  def update
    if @additional_description.update_attributes(params[:additional_description])
      flash[:success] = success_message_for(controller_name)
      redirect_to cms_real_estate_media_assets_path(@real_estate)
    else
      render 'edit'
    end
  end

  def show
    respond_with @additional_description
  end

end
