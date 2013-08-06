class Cms::ImagesController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  load_resource :class=>MediaAssets::Image, :through => :real_estate
  authorize_resource :class=>MediaAssets::Image, :through => :real_estate, :except => :show

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
    @image = @real_estate.images.create(params[:image])
    redirect_to edit_cms_real_estate_image_path(@real_estate, @image)
  end

  def update
    @image.update_attributes(params[:image])
    redirect_to cms_real_estate_image_path(@real_estate, @image)
  end

  def destroy
    @image.destroy
    redirect_to [:cms, @real_estate, :media_assets]
  end
end
