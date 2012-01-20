class Cms::FiguresController < Cms::SecuredController

  before_filter :load_real_estate

  def new
    @figure = Figure.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @figure }
    end
  end

  def edit
    @figure = @real_estate.figure
  end

  def create
    @figure = Figure.new(params[:figure])
    @figure.real_estate = @real_estate

    respond_to do |format|
      if @figure.save
        format.html { redirect_to edit_cms_real_estate_figure_path(@real_estate) }
        format.json { render :json => @figure, :status => :created, :location => @figure }
      else
        format.html { render :action => "new" }
        format.json { render :json => @figure.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @figure = @real_estate.figure

    respond_to do |format|
      if @figure.update_attributes(params[:figure])
        format.html { redirect_to edit_cms_real_estate_figure_path(@real_estate) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @figure.errors, :status => :unprocessable_entity }
      end
    end
  end

protected
  
  def load_real_estate
    @real_estate = RealEstate.find(params[:real_estate_id])    
  end
end
