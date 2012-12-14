module Cms
  module SecuredHelper

    def fireable_events(real_estate)
      events = RealEstate.state_machine.events
      events.valid_for(real_estate).select {|event| can?(event.name, real_estate)}
    end

    def highlight_invalid_tab(tab)
      'invalid' if @real_estate.errors.include?(tab)
    end

    def mark_mandatory_tab(tab)
      "mandatory" if RealEstate.mandatory_for_publishing.include?(tab.to_s)
    end

    def event_button_css(event)
      case event.name
        when :reject_it, :unpublish_it
          "btn btn-danger span2"
        else
          "btn btn-success span2"
      end
    end

    def accessible?(attribute)
      @field_access.accessible?(controller.editing_model, attribute)
    end

    def exhibit_form_for(model, &block)
      form_for model, :url => send("cms_real_estate_#{model.class.name.singularize.underscore}_path", @real_estate) do |form|
        model = RealEstateExhibit.create(model, :rent, :living).new(model, self, :form => form)
        block.yield(form, model)
      end
    end

  end
end
