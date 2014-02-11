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
    changed = update_html_inputs

    if @figure.save
      return render 'edit' if changed
      redirect_to_step(next_step_after('figure'))
    else
      render 'new'
    end
  end

  def update
    @figure.attributes = params[:figure]
    changed = update_html_inputs

    if @figure.save && !changed
      redirect_to_step(next_step_after('figure'))
    else
      render 'edit'
    end
  end

  private
  def update_html_inputs
    @original_offer_html = @figure.offer_html.try(&:html_safe)

    decorator = FigureDecorator.new(@figure)
    @offer_html_changed = decorator.update_list_in(:offer)

    @offer_html_changed
  end
end
