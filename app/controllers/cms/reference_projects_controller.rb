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
      @reference_projects = ReferenceProject.where(:locale => content_locale)
    end

    def edit
    end

    def new
      @reference_project = ReferenceProject.new(:locale => content_locale)
    end

    def create
      @reference_project = ReferenceProject.new(params[:reference_project])

      if @reference_project.save
        flash[:success] = %(Das Referenzprojekt "#{@reference_project.title}" wurde erfolgreich gespeichert.)
        redirect_to cms_reference_projects_path(:content_locale => @reference_project.locale)
      else
        render 'new'
      end
    end


    def update
      @reference_project = ReferenceProject.find params[:id]
      @reference_project.assign_attributes(params[:reference_project])
      update_position = @reference_project.position_changed?

      if @reference_project.save
        update_position_attribute(@reference_project) if update_position
        respond_to do |format|
          format.js { flash.now[:success] = t('cms.reference_projects.update.sorted.success') }
          format.html
        end
      end
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

