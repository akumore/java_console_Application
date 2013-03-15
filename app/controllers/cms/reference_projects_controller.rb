module Cms
  class ReferenceProjectsController < Cms::SecuredController

    authorize_resource

    rescue_from CanCan::AccessDenied do |err|
      redirect_to cms_dashboards_path, :alert => err.message
    end

    rescue_from Mongoid::Errors::DocumentNotFound do |err|
      flash[:warn] = "Gesuchtes Referenzprojekt wurde nicht gefunden"
      redirect_to cms_reference_projects_path
    end

    def index
      @reference_projects = ReferenceProject.all.where(:locale => content_locale)
    end

    def edit
      @reference_project = ReferenceProject.find params[:id]
      @real_estates = RealEstate.all
    end

    def new
      @reference_project = ReferenceProject.new(:locale => content_locale)
      @real_estates = RealEstate.all
    end

    def create
      @reference_project = ReferenceProject.new(params[:reference_project])
      if @reference_project.save
        flash[:success] = t("flash.actions.create.notice", :resource_name => @reference_project.title)
        redirect_to cms_reference_projects_path(:content_locale => @reference_project.locale)
      else
        @real_estates = RealEstate.all
        render 'new'
      end
    end

    def update
      @reference_project = ReferenceProject.find params[:id]
      if @reference_project.update_attributes(params[:reference_project])
        flash[:success] = t("flash.actions.update.notice", :resource_name => @reference_project.title)
        redirect_to cms_reference_projects_path(:content_locale => @reference_project.locale)
      else
        @real_estates = RealEstate.all
        render 'edit'
      end
    end

    def destroy
      @reference_project = ReferenceProject.find params[:id]
      if @reference_project.destroy
        flash[:success] = t("flash.actions.destroy.notice", :resource_name => @reference_project.title)
      end
      redirect_to cms_reference_projects_path(:content_locale => @reference_project.locale)
    end

    def sort
      if params[:reference_projects].present?
        params[:reference_projects].each do |id_position_map|
          id_position_map.each do |id, position|
            ReferenceProject.find(id).update_attributes!(:position => position[:position].to_i)
          end
        end
      end
      render :nothing => true
    end
  end
end
