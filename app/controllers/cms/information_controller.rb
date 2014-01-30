class Cms::InformationController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  load_resource :through => :real_estate, :singleton => true
  authorize_resource :through => :real_estate, :singleton => true, :except => :show

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_information_path(@real_estate), :alert => exception.message
  end


  def new
    @information = Information.new
    @information.build_points_of_interest(@real_estate)
    respond_with @information
  end

  def edit
    @information.build_points_of_interest(@real_estate)
  end

  def create
    changed = update_html_inputs

    if @information.save
      return render 'edit' if changed
      redirect_to_step(next_step_after('information'))
    else
      render 'new'
    end
  end

  def update
    @information.attributes = params[:information]
    changed = update_html_inputs

    if @information.save && !changed
      redirect_to_step(next_step_after('information'))
    else
      render 'edit'
    end
  end

  def show
  end

  private
  def update_html_inputs
    @original_location_html = @information.location_html.html_safe
    @original_additional_information = @information.additional_information.html_safe

    decorator = InformationDecorator.new(@information)
    @location_html_changed = decorator.update_list_in(:location_characteristics, :location_html)
    @additional_information_changed = decorator.update_list_in(:characteristics, :additional_information)

    @location_html_changed || @additional_information_changed
  end
end
