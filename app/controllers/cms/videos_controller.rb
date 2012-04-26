class Cms::VideosController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  load_resource :class=>MediaAssets::Video, :through => :real_estate
  authorize_resource :class=>MediaAssets::Video, :through => :real_estate, :except => :show

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
    @video = @real_estate.videos.create(params[:video])
    respond_with @video, :location => cms_real_estate_media_assets_path
  end

  def update
    @video.update_attributes(params[:video])
    respond_with @video, :location => cms_real_estate_media_assets_path
  end

  def destroy
    @video.destroy
    redirect_to cms_real_estate_media_assets_path
  end
end
