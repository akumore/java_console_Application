class Cms::InfrastructuresController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  load_resource :through => :real_estate, :singleton => true
      authorize_resource :through => :real_estate, :singleton => true, :except => :show

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_infrastructure_path(@real_estate), :alert => exception.message
  end


  def new
    @infrastructure = Infrastructure.new
    @infrastructure.build_points_of_interest(@real_estate)
    respond_with @infrastructure
  end

  def edit
    @infrastructure.build_points_of_interest(@real_estate)
  end

  def create
    if @infrastructure.save
      redirect_to_step(next_step_after('infrastructure'))
    else
      render 'new'
    end
  end

  def update
    if @infrastructure.update_attributes(params[:infrastructure])
      redirect_to_step(next_step_after('infrastructure'))
    else
      render 'edit'
    end
  end

  def show
  end

end
