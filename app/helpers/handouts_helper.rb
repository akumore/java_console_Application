module HandoutsHelper

  def characteristics
    info    = @real_estate.information
    buffer  = []

    buffer << t('.new_building') if info.is_new_building?
    buffer << t('.old_building') if info.is_old_building?
    buffer << t('.minergie_style') if info.is_minergie_style?
    buffer << t('.minergie_certified') if info.is_minergie_certified?

    if @real_estate.private_utilization?
      buffer << t('.view') if info.has_outlook?
      buffer << t('.fireplace') if info.has_fireplace?
      buffer << t('.elevator') if info.has_elevator?
      buffer << t('.isdn') if info.has_isdn?
      buffer << t('.wheelchair_accessible') if info.is_wheelchair_accessible?
      buffer << t('.child_friendly') if info.is_child_friendly?
      buffer << t('.balcony') if info.has_balcony?
      buffer << t('.raised_ground_floor') if info.has_raised_ground_floor?
      buffer << t('.swimmingpool') if info.has_swimming_pool?
    else
      if info.number_of_restrooms > 0
        buffer << t('.number_of_restrooms', :count => info.number_of_restrooms)
      end

      buffer << t('.ramp') if info.has_ramp?
      buffer << t('.lifting_platform') if info.has_lifting_platform?
      buffer << t('.railway_terminal') if info.has_railway_terminal?
      buffer << t('.water_supply') if info.has_water_supply?
      buffer << t('.sewage_supply') if info.has_sewage_supply?
    end

    buffer.compact
  end

end
