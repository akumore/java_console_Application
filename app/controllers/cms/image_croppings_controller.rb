class Cms::ImageCroppingsController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  # load_resource :class => MediaAssets::Image, :through => :real_estate
  # authorize_resource :class => MediaAssets::Image, :through => :real_estate, :except => :show
  
  respond_to :html
  
  rescue_from CanCan::AccessDenied do |err|
    redirect_to cms_dashboards_path
  end

  def edit
    if params[:image_type] == 'floor_plan'
      @image = @real_estate.floor_plans.find(params[:id])
    else
      @image = @real_estate.images.find(params[:id])
    end

    render :edit , locals: { image_type: params[:image_type] }
  end
end
