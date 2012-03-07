class Cms::FiguresController < Cms::SecuredController
  include EmbeddedInRealEstate

  def new
    @figure = Figure.new
    respond_with @figure
  end

  def edit
    @figure = @real_estate.figure
  end

  def create
    @figure = Figure.new(params[:figure])
    @figure.real_estate = @real_estate

    if @figure.save
      redirect_to edit_cms_real_estate_figure_path(@real_estate)
    else
      render 'new'
    end
  end

  def update
    @figure = @real_estate.figure

    if @figure.update_attributes(params[:figure])
      redirect_to edit_cms_real_estate_figure_path(@real_estate)
    else
      render 'edit'
    end
  end
end
