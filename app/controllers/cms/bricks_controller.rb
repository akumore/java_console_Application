class Cms::BricksController < Cms::SecuredController

  before_filter :load_page
  respond_to :html

  def new
    @brick = @page.bricks.build({}, brick_from_type)
    respond_with @brick
  end

  def create
    @brick = @page.bricks.build(params[brick_name], brick_from_type)
    @brick.position = @page.bricks.size + 1

    if @brick.save
      redirect_to edit_cms_page_path(@page)
    else
      render 'new'
    end
  end

  def edit
    @brick = @page.bricks.find(params[:id])
    respond_with @brick
  end

  def update
    @brick = @page.bricks.find(params[:id])
    if @brick.update_attributes(params[brick_name])
      redirect_to edit_cms_page_path(@page)
    else
      render 'edit'
    end
  end

  def destroy
    brick = @page.bricks.find(params[:id])
    brick.destroy
    redirect_to edit_cms_page_path(@page)
  end

  private

  def load_page
    @page = Page.find(params[:page_id])
  end

  def brick_from_type type = nil
    type ||= params[:type]
    "brick/#{type}".classify.constantize
  end

  def brick_name
    "brick_#{params[:type]}".underscore.to_sym
  end
end