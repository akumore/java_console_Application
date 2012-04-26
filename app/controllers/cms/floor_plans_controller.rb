class Cms::FloorPlansController < Cms::SecuredController
  include EmbeddedInRealEstate

  load_resource :class=>MediaAssets::FloorPlan, :through => :real_estate
  authorize_resource :class=>MediaAssets::FloorPlan, :through => :real_estate, :except => :show

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
    @floor_plan = @real_estate.floor_plans.create(params[:floor_plan])
    respond_with @floor_plan, :location => cms_real_estate_media_assets_path
  end

  def update
    @floor_plan.update_attributes(params[:floor_plan])
    respond_with @floor_plan, :location => cms_real_estate_media_assets_path
  end

  def destroy
    @floor_plan.destroy
    redirect_to cms_real_estate_media_assets_path
  end
end
