class Cms::FiguresController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  load_resource :through => :real_estate, :singleton => true
  authorize_resource :through => :real_estate, :singleton => true, :except => :show

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_figure_path(@real_estate), :alert => exception.message
  end

  def new
  end

  def edit
  end

  def show
  end

  def create
    if @figure.save
      redirect_to_step('infrastructure')
    else
      render 'new'
    end
  end

  def update
    if @figure.update_attributes(params[:figure])
      redirect_to_step('infrastructure')
    else
      render 'edit'
    end
  end

end
