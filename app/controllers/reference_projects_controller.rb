class ReferenceProjectsController < ApplicationController

  before_filter :set_search_filter

  def index
    @gallery_photos = GalleryPhotoDecorator.decorate GalleryPhoto.all
    @reference_projects = get_filtered_reference_projects(@search_filter)

    respond_to do |format|
      format.html { @reference_projects = @reference_projects.limit(4) }
      format.js { @reference_projects = @reference_projects.all }
    end
  end

  private

  def set_search_filter
    filter_params = (params[:search_filter] || {}).reverse_merge(:section => params[:section])
    @search_filter = Search::ReferenceProjectsFilter.new(filter_params)
  end

  def get_filtered_reference_projects(search_filter)
    ReferenceProject.where( :locale => I18n.locale, :section => search_filter.section, :displayed_on => ReferenceProject::REFERENCE_PROJECT_PAGE )
  end
end
