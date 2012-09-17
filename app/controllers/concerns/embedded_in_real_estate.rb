module Concerns
  module EmbeddedInRealEstate
    extend ActiveSupport::Concern

    included do
      # Use CanCan loader
      load_resource :real_estate
      before_filter :save_editor, :only => [:update, :create]
    end

    def success_message_for name
      "#{name.singularize.classify.constantize.model_name.human} erfolgreich gespeichert."
    end

    def redirect_to_step name
      flash[:success] = success_message_for(controller_name)
      if @real_estate.send(name).present?
        redirect_to send("edit_cms_real_estate_#{name.singularize}_path", @real_estate)
      else
        redirect_to send("new_cms_real_estate_#{name.singularize}_path", @real_estate)
      end
    end

    def save_editor
      @real_estate.editor = current_user
    end
  end
end
