class Cms::InformationController < Cms::SecuredController
  include EmbeddedInRealEstate

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_information_path(@real_estate), :alert => exception.message
  end


  def new
    @information = Information.new
  end

  def edit
  end

  def create
    if @information.save
      redirect_to_step('pricing')
    else
      render 'new'
    end
  end

  def update
    if @information.update_attributes(params[:information])
      redirect_to_step('pricing')
    else
      render 'edit'
    end    
  end

  def show
  end
  
end
