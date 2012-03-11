class Cms::InfrastructuresController < Cms::SecuredController
  include EmbeddedInRealEstate

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_infrastructure_path(@real_estate), :alert => exception.message
  end


  def new
    @infrastructure = Infrastructure.new
    @infrastructure.build_all_points_of_interest
    respond_with @infrastructure
  end

  def edit
    @infrastructure.build_all_points_of_interest
  end

  def create
    if @infrastructure.save
      redirect_to_step('description')
    else
      render 'new'
    end
  end

  def update
    if @infrastructure.update_attributes(params[:infrastructure])
      redirect_to_step('description')
    else
      render 'edit'
    end
  end
  
  def show
  end
  
end
