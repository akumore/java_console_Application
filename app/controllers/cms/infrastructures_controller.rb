class Cms::InfrastructuresController < Cms::SecuredController
  include EmbeddedInRealEstate

  def new
    @infrastructure = Infrastructure.new
    @infrastructure.build_all_points_of_interest
    respond_with @infrastructure
  end

  def edit
    @infrastructure = @real_estate.infrastructure
    @infrastructure.build_all_points_of_interest
  end

  def create
    @infrastructure = Infrastructure.new(params[:infrastructure])
    @infrastructure.real_estate = @real_estate

    if @infrastructure.save
      redirect_to edit_cms_real_estate_infrastructure_path(@real_estate)
    else
      render 'new'
    end
  end

  def update
    @infrastructure = @real_estate.infrastructure

    if @infrastructure.update_attributes(params[:infrastructure])
      redirect_to edit_cms_real_estate_infrastructure_path(@real_estate)
    else
      render 'edit'
    end
  end
end
