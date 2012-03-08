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
      redirect_to_step('infrastructure')
    else
      render 'new'
    end
  end

  def update
    @figure = @real_estate.figure

    if @figure.update_attributes(params[:figure])
      redirect_to_step('infrastructure')
    else
      render 'edit'
    end
  end
end
