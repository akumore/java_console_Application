class Cms::FloorPlansController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  load_resource :class => MediaAssets::FloorPlan, :through => :real_estate
  authorize_resource :class => MediaAssets::FloorPlan, :through => :real_estate, :except => :show

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
    if @floor_plan.valid?
      render :edit
    else
      render :new
    end
  end

  def update
    @floor_plan.update_attributes(params[:floor_plan])
    if @floor_plan.valid? && params[:floor_plan][:crop_x].blank?
      redirect_to [:cms, @real_estate, :media_assets]
    else
      render :edit
    end
  end

  def destroy
    @floor_plan.destroy
    redirect_to [:cms, @real_estate, :media_assets]
  end
end
