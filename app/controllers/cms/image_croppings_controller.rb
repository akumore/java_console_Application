class Cms::ImageCroppingsController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  # load_resource :class => MediaAssets::Image, :through => :real_estate
  # authorize_resource :class => MediaAssets::Image, :through => :real_estate, :except => :show
  
  respond_to :html
  
  rescue_from CanCan::AccessDenied do |err|
    redirect_to cms_dashboards_path
  end

  def edit
    @image = @real_estate.images.find(params[:id])
  end

   def update
    @image.update_attributes(params[:image])
    redirect_to cms_real_estate_image_path(@real_estate, @image)
  end

end
