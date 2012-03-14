module Cms
  module SecuredHelper

    def can_be_edited?(real_estate)
      can?(:update, real_estate) && !real_estate.published?
    end

    def fireable_events(real_estate)
      events = RealEstate.state_machine.events
      events.valid_for(real_estate).select {|event| can?(event.name, real_estate)}
    end

    def event_button_css(event)
      case event.name
        when :reject_it, :unpublish_it
          "btn btn-danger span2"
        else
          "btn btn-success span2"
      end
    end

  end
end