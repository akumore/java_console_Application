class Cms::DocumentsController < Cms::SecuredController
  include EmbeddedInRealEstate

  load_resource :class=>MediaAssets::Document, :through => :real_estate
  authorize_resource :class=>MediaAssets::Document, :through => :real_estate, :except => :show

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_media_assets_path(@real_estate), :alert => exception.message
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @document = @real_estate.documents.create(params[:document])
    respond_with @document, :location => cms_real_estate_media_assets_path
  end

  def update
    @document.update_attributes(params[:document])
    respond_with @document, :location => cms_real_estate_media_assets_path
  end

  def destroy
    @document.destroy
    redirect_to cms_real_estate_media_assets_path
  end
end
