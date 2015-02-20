# encoding: utf-8

class Cms::TeasersController < Cms::SecuredController
  respond_to :html
  authorize_resource

  rescue_from CanCan::AccessDenied do |err|
    redirect_to cms_dashboards_path, :alert => err.message
  end

  def index
    @teasers = Teaser.where(:locale => content_locale).order([:updated_at, :desc])
    respond_with @teasers
  end

  def new
    @teaser = Teaser.new(:locale => content_locale)
    respond_with @teaser
  end

  def create
    @teaser = Teaser.new(params[:teaser])

    if @teaser.save
      flash[:success] = %(Der Teaser "#{@teaser.title}" wurde erfolgreich gespeichert.)
      redirect_to cms_teasers_path
    else
      render 'new'
    end
  end

  def edit
    @teaser = Teaser.find(params[:id])
    respond_with @teaser
  end

  def update
    @teaser = Teaser.find(params[:id])

    if @teaser.update_attributes(params[:teaser])
      flash[:success] = %(Der Teaser "#{@teaser.title}" wurde erfolgreich gespeichert.)
      redirect_to edit_cms_teaser_path(@teaser)
    else
      render 'edit'
    end
  end

  def destroy
    teaser = Teaser.find(params[:id])
    teaser.destroy
    flash[:alert] = %(Der Teaser "#{teaser.title}" wurde erfolgreich gelöscht.)
    redirect_to cms_teasers_path
  end

  def sort
    if params[:teasers].present?
      params[:teasrs].each do |id_position_map|
        id_position_map.each do |id, position|
          Teaser.find(id).update_attributes!(:position => position[:position].to_i)
        end
      end
    end
    render :nothing => true
  end
end
