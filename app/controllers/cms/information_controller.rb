class Cms::InformationController < Cms::SecuredController
  include EmbeddedInRealEstate

  def new
    @information = Information.new
    @information.real_estate = @real_estate
  end

  def edit
    @information = @real_estate.information
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

    if @information.update_attributes(params[:information])
      redirect_to_step('pricing')
    else
      render 'edit'
    end    
  end
end
