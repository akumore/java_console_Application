class Cms::InformationController < Cms::SecuredController
  include EmbeddedInRealEstate

  respond_to :html, :json

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_information_path(@real_estate), :alert => exception.message
  end


  def new
    @information = Information.new
    @information.real_estate = @real_estate
  end

  def edit
    @information = @real_estate.information
    authorize! :update,  @real_estate
  end

  def create
    @information = Information.new(params[:information])
    @information.real_estate = @real_estate

    if @information.save
      redirect_to_step('pricing')
    else
      render 'new'
    end
  end

  def update
    @information = @real_estate.information
    authorize! :update,  @real_estate

    if @information.update_attributes(params[:information])
      redirect_to_step('pricing')
    else
      render 'edit'
    end    
  end

  def show
    @real_estate = RealEstate.find params[:real_estate_id]
    @information = @real_estate.information
  end
  
end
