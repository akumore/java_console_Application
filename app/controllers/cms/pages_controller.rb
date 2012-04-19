class Cms::PagesController < Cms::SecuredController
  respond_to :html
  authorize_resource

  rescue_from CanCan::AccessDenied do |err|
    flash[:warn] = err.message
    redirect_to cms_dashboards_path
  end

  def index
    @pages = Page.all.where(:locale => content_locale).order([:updated, :asc])
    respond_with @pages
  end

  def new
    @page = Page.new(:locale => content_locale)
    respond_with @page
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to edit_cms_page_path(@page)
    else
      render 'new'
    end
  end

  def edit
    @page = Page.find(params[:id])
    respond_with @page
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      redirect_to edit_cms_page_path(@page)
    else
      render 'edit'
    end
  end

  def destroy
    page = Page.find(params[:id])
    page.destroy
    redirect_to cms_pages_path
  end
end
