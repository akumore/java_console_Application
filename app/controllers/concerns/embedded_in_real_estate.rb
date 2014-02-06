require 'field_access'

module Concerns
  module EmbeddedInRealEstate
    extend ActiveSupport::Concern

    included do
      # Use CanCan loader
      load_resource :real_estate
      before_filter :save_editor, :only => [:update, :create]
    end

    EXISTING_TABS = ['address', 'figure', 'pricing', 'information', 'media_assets']

    def success_message_for(name)
      "#{name.singularize.classify.constantize.model_name.human} erfolgreich gespeichert."
    end

    def redirect_to_step(name)
      flash[:success] = success_message_for(controller_name)
      if name == 'media_assets'
        redirect_to cms_real_estate_media_assets_path(@real_estate)
      else
        if @real_estate.send(name).present?
          redirect_to send("edit_cms_real_estate_#{name.singularize}_path", @real_estate)
        else
          redirect_to send("new_cms_real_estate_#{name.singularize}_path", @real_estate)
        end
      end
    end

    def get_available_tabs
      EXISTING_TABS.select { |tab| @real_estate.to_model_access.accessible?(tab) }
    end

    def next_step_after(name)
      get_available_tabs[get_available_tabs.index(name) + 1]
    end

    def save_editor
      @real_estate.update_attribute :editor_id, current_user.id
    end

    def editing_model
      model_name = controller_name.singularize
      instance_variable_get("@#{model_name}")
    end

    def field_access
      @field_access ||= FieldAccess.new(@real_estate.offer, @real_estate.utilization, FieldAccess.cms_blacklist)
    end
  end
end
