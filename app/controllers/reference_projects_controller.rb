class ReferenceProjectsController < ApplicationController

  def index
    @gallery_photos = ReferenceProjectDecorator.decorate GalleryPhoto.all
    @reference_projects = ReferenceProjectDecorator.decorate ReferenceProject.where(:locale => I18n.locale)
  end
end
