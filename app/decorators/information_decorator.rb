class InformationDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :information

  def available_from_compact
    I18n.t('information.available_from_compact', :date => available_from) if available_from.present?
  end

  def available_from
    if model.display_estimated_available_from.present?
      model.display_estimated_available_from
    elsif model.available_from.present?
      I18n.l(model.available_from)
    end
  end

  def characteristics
    buffer  = []

    buffer << t('information.new_building') if model.is_new_building?
    buffer << t('information.old_building') if model.is_old_building?
    buffer << t('information.minergie_style') if model.is_minergie_style?
    buffer << t('information.minergie_certified') if model.is_minergie_certified?

    if model.private_utilization?
      buffer << t('information.view') if model.has_outlook?
      buffer << t('information.fireplace') if model.has_fireplace?
      buffer << t('information.elevator') if model.has_elevator?
      buffer << t('information.isdn') if model.has_isdn?
      buffer << t('information.wheelchair_accessible') if model.is_wheelchair_accessible?
      buffer << t('information.child_friendly') if model.is_child_friendly?
      buffer << t('information.balcony') if model.has_balcony?
      buffer << t('information.raised_ground_floor') if model.has_raised_ground_floor?
      buffer << t('information.swimmingpool') if model.has_swimming_pool?
    elsif model.commercial_utilization?
      if model.number_of_restrooms.to_i > 0
        buffer << t('information.number_of_restrooms', :count => model.number_of_restrooms)
      end

      buffer << t('information.ramp') if model.has_ramp?
      buffer << t('information.lifting_platform') if model.has_lifting_platform?
      buffer << t('information.railway_terminal') if model.has_railway_terminal?
      buffer << t('information.water_supply') if model.has_water_supply?
      buffer << t('information.sewage_supply') if model.has_sewage_supply?
    end

    buffer.compact
  end

  def maximal_floor_loading
    if model.maximal_floor_loading.present?
      t('information.maximal_floor_loading_value', :count => model.maximal_floor_loading )
    end
  end

  def freight_elevator_carrying_capacity
    if model.freight_elevator_carrying_capacity.present?
      t('information.freight_elevator_carrying_capacity_value', :count => model.freight_elevator_carrying_capacity )
    end
  end
end
