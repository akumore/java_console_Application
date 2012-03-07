class Cms::MediaAssetsController < Cms::SecuredController
  include EmbeddedInRealEstate
  
  # GET /cms/media_assets
  # GET /cms/media_assets.json
  def index
    @media_assets = @real_estate.media_assets

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @media_assets }
    end
  end

  # GET /cms/media_assets/new
  # GET /cms/media_assets/new.json
  def new
    @media_asset = MediaAsset.new(:media_type => params[:media_type])
  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @media_asset }
    end
  end

  # GET /cms/media_assets/1/edit
  def edit
    @media_asset = @real_estate.media_assets.find(params[:id])
  end

  # POST /cms/media_assets
  # POST /cms/media_assets.json
  def create
    @media_asset = @real_estate.media_assets.build(params[:media_asset])

    respond_to do |format|
      if @media_asset.save
        format.html { redirect_to edit_cms_real_estate_media_asset_path(@real_estate, @media_asset) }
        format.json { render :json => @media_asset, :status => :created, :location => @media_asset }
      else
        format.html { render :action => "new" }
        format.json { render :json => @media_asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cms/media_assets/1
  # PUT /cms/media_assets/1.json
  def update
    @media_asset = @real_estate.media_assets.find(params[:id])

    respond_to do |format|
      if @media_asset.update_attributes(params[:media_asset])
        format.html { redirect_to edit_cms_real_estate_media_asset_path(@real_estate, @media_asset) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @media_asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cms/media_assets/1
  # DELETE /cms/media_assets/1.json
  def destroy
    @media_asset = @real_estate.media_assets.find(params[:id])
    @media_asset.destroy

    respond_to do |format|
      format.html { redirect_to cms_real_estate_media_assets_url }
      format.json { head :ok }
    end
  end
end
