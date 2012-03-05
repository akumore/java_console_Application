module Cms
  module SecuredHelper

    def fireable_events(real_estate)
      events = RealEstate.state_machine.events
      events.valid_for(real_estate).select {|event| can?(event.name, real_estate)}
    end

  end
end