class ReferenceProjectsController < ApplicationController

  def index
    @gallery_photos = ReferenceProjectDecorator.decorate GalleryPhoto.all
    @reference_projects = ReferenceProjectDecorator.decorate ReferenceProject.all
  end
end
