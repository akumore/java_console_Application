class Cms::MediaAssetsController < Cms::SecuredController
  include EmbeddedInRealEstate

  authorize_resource :real_estate, :only => [:edit, :update]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_media_assets_path(@real_estate), :alert => exception.message
  end
  
  
  def index
    @media_assets = @real_estate.media_assets
    respond_with @media_assets
  end

  def new
    @media_asset = MediaAsset.new(:media_type => params[:media_type])
    respond_with @media_asset  
  end

  def edit
    @media_asset = @real_estate.media_assets.find(params[:id])
  end

  def create
    @media_asset = @real_estate.media_assets.build(params[:media_asset])

    if @media_asset.save
      redirect_to edit_cms_real_estate_media_asset_path(@real_estate, @media_asset)
    else
      render 'new'
    end
  end

  def update
    @media_asset = @real_estate.media_assets.find(params[:id])

    if @media_asset.update_attributes(params[:media_asset])
      redirect_to edit_cms_real_estate_media_asset_path(@real_estate, @media_asset)
    else
      render 'edit'
    end
  end

  def destroy
    @media_asset = @real_estate.media_assets.find(params[:id])
    @media_asset.destroy
    redirect_to cms_real_estate_media_assets_url
  end
end
