class InformationDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :information

  def available_from_compact
    if available_from.present?
      I18n.t('information.available_from_compact', :date => available_from)
    end
  end

  def available_from
    if model.display_estimated_available_from.present?
      model.display_estimated_available_from
    elsif model.available_from.present?
      if model.available_from.past?
        I18n.t('information.available_immediately')
      else
        I18n.l(model.available_from)
      end
    end
  end

  def characteristics
    buffer  = []

    buffer << t('information.new_building') if model.is_new_building?
    buffer << t('information.old_building') if model.is_old_building?
    buffer << t('information.minergie_style') if model.is_minergie_style?
    buffer << t('information.minergie_certified') if model.is_minergie_certified?

    if model.living?
      buffer << t('information.view') if model.has_outlook?
      buffer << t('information.fireplace') if model.has_fireplace?
      buffer << t('information.elevator') if model.has_elevator?
      buffer << t('information.isdn') if model.has_isdn?
      buffer << t('information.wheelchair_accessible') if model.is_wheelchair_accessible?
      buffer << t('information.child_friendly') if model.is_child_friendly?
      buffer << t('information.balcony') if model.has_balcony?
      buffer << t('information.raised_ground_floor') if model.has_raised_ground_floor?
      buffer << t('information.swimmingpool') if model.has_swimming_pool?
    elsif model.working? || model.storing?
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

  def chapter
    content = []
    content_html = ''

    figure = FigureDecorator.decorate real_estate.figure
    if figure && real_estate.living?
      if figure.floor.present?
        content << { :key => t('figures.floor'), :value => figure.floor }
      end

      if figure.rooms.present?
        content << { :key => t('figures.rooms'), :value => figure.rooms }
      end

      if figure.surface.present?
        content << { :key => figure.surface_label, :value => figure.surface }
      end
    end

    if figure && real_estate.working?
      if figure.property_surface.present?
        content << { :key => t('figures.property_surface'),:value => figure.property_surface }
      end

      if figure.ceiling_height.present?
        content << { :key => t('figures.ceiling_height'), :value => figure.ceiling_height}
      end

      if figure.storage_surface.present?
        content << { :key => t('figures.storage_surface') , :value => figure.storage_surface }
      end
    end

    if figure && figure.floors.present?
      content << { :key => t('figures.floors'), :value => figure.floors }
    end

    if figure && figure.renovated_on.present?
      content << { :key => t('figures.renovated_on'), :value => figure.renovated_on }
    end

    if figure && figure.built_on.present?
      content << { :key => t('figures.built_on'), :value => figure.built_on }
    end

    if characteristics.any?
      content << { :key => t('information.characteristics'), :value => characteristics.join(', ') }
    end

    if real_estate.working?
      if maximal_floor_loading.present?
        content << { :key => t('information.maximal_floor_loading'), :value => maximal_floor_loading }
      end

      if freight_elevator_carrying_capacity.present?
        content << { :key => t('information.freight_elevator_carrying_capacity'), :value => freight_elevator_carrying_capacity }
      end
    end

    {
      :title        => t('information.title'),
      :collapsible  => true,
      :content_html => content_html,
      :content      => content
    }
  end
end
