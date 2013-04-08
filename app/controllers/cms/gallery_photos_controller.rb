# encoding: utf-8
#
module Cms
  class GalleryPhotosController < Cms::SecuredController

    authorize_resource

    rescue_from CanCan::AccessDenied do |err|
      redirect_to cms_dashboards_path, :alert => err.message
    end

    rescue_from Mongoid::Errors::DocumentNotFound do |err|
      flash[:warn] = "Gesuchtes Foto wurde nicht gefunden"
      redirect_to cms_gallery_photos_path
    end

    def index
      @gallery_photos = GalleryPhoto.all
      respond_with @gallery_photos
    end

    def new
      @gallery_photo = GalleryPhoto.new
      respond_with @gallery_photo
    end

    def create
      @gallery_photo = GalleryPhoto.new(params[:gallery_photo])

      if @gallery_photo.save
        flash[:success] = %(Das Foto "#{@gallery_photo.title}" wurde erfolgreich gespeichert.)
        redirect_to cms_gallery_photos_path
      else
        render 'new'
      end
    end

    def edit
      @gallery_photo = GalleryPhoto.find(params[:id])
      respond_with @gallery_photo
    end

    def update
      @gallery_photo = GalleryPhoto.find(params[:id])

      if @gallery_photo.update_attributes(params[:gallery_photo])
        flash[:succes] = %(Das Foto "#{@gallery_photo.title}" wurde erfolgreich gespeichert.)
        redirect_to edit_cms_gallery_photo_path(@gallery_photo)
      else
        render 'edit'
      end
    end

    def destroy
      gallery_photo = GalleryPhoto.find(params[:id])
      gallery_photo.destroy
      flash[:alert] = %(Das Foto "#{gallery_photo.title}" wurde erfolgreich gelöscht.)
      redirect_to cms_gallery_photos_path
    end

    def sort
      if params[:gallery_photos].present?
        params[:gallery_photos].each do |id_position_map|
          id_position_map.each do |id, position|
            GalleryPhoto.find(id).update_attributes!(:position => position[:position].to_i)
          end
        end
      end
      render :nothing => true
    end
  end
end
