class Cms::InformationController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  load_resource :through => :real_estate, :singleton => true
  authorize_resource :through => :real_estate, :singleton => true, :except => :show

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cms_real_estate_information_path(@real_estate), :alert => exception.message
  end


  def new
    @information = Information.new
  end

  def edit
  end

  def create
    @original_additional_information = @information.additional_information.html_safe

    changed = InformationDecorator.new(@information).update_additional_information

    if @information.save
      return render 'edit' if changed
      redirect_to_step(next_step_after('information'))
    else
      render 'new'
    end
  end

  def update
    @information.attributes = params[:information]
    @original_additional_information = @information.additional_information.html_safe

    changed =  InformationDecorator.new(@information).update_additional_information

    if @information.save && !changed
      redirect_to_step(next_step_after('information'))
    else
      render 'edit'
    end
  end

  def show
  end

end
