class ReferenceProjectsController < ApplicationController

  def index
    @gallery_photos = GalleryPhotoDecorator.decorate GalleryPhoto.all
    @reference_projects = ReferenceProjectDecorator.decorate ReferenceProject.where(:locale => I18n.locale)

    respond_to do |format|
      format.html { @reference_projects = @reference_projects.limit(4) }
      format.js   { @reference_projects = @reference_projects.all }
    end
  end
end
