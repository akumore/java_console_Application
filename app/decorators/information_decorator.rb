class InformationDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :information

  def characteristics
    buffer  = []
    
    buffer << t('information.minergie_style') if model.is_minergie_style?
    buffer << t('information.minergie_certified') if model.is_minergie_certified?
    buffer << t('information.cable_tv') if model.has_cable_tv?

    if model.living?
      buffer << t('information.view') if model.has_outlook?
      buffer << t('information.fireplace') if model.has_fireplace?
      buffer << t('information.elevator') if model.has_elevator?
      buffer << t('information.isdn') if model.has_isdn?
      buffer << t('information.wheelchair_accessible') if model.is_wheelchair_accessible?
      buffer << t('information.child_friendly') if model.is_child_friendly?
      buffer << t('information.balcony') if model.has_balcony?
      buffer << t('information.garden_seating') if model.has_garden_seating?
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
      buffer << t('information.freight_elevator') if model.has_freight_elevator?
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
    if figure && (real_estate.living? || real_estate.storing?)
      if figure.floor.present?
        content << { :key => t('figures.floor'), :value => figure.floor }
      end

      if figure.surface.present?
        content << { :key => figure.surface_label, :value => figure.surface }
      end

      if real_estate.living?
        if figure.rooms.present?
          content << { :key => t('figures.rooms'), :value => figure.rooms }
        end
      end
    end

    if figure && real_estate.working?
      if figure.property_surface.present?
        content << { :key => t('figures.property_surface'),:value => figure.property_surface }
      end

      if information.ceiling_height.present?
        content << { :key => t('information.ceiling_height'), :value => information.ceiling_height}
      end

      if figure.storage_surface.present?
        content << { :key => t('figures.storage_surface') , :value => figure.storage_surface }
      end
    end

    if information && information.floors.present?
      content << { :key => t('information.floors'), :value => information.floors }
    end

    if information && information.renovated_on.present?
      content << { :key => t('information.renovated_on'), :value => information.renovated_on }
    end

    if information && information.built_on.present?
      content << { :key => t('information.built_on'), :value => information.built_on }
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

    if location_characteristics.any?
      content << {
        :key => t('information.location'),
        :value => location_characteristics.join(', ')
      }
    end

    {
      :title        => t('information.title'),
      :collapsible  => true,
      :content_html => content_html,
      :content      => content
    }
  end

  def additional_information
    if model.additional_information.present?
      model.additional_information.html_safe
    end
  end

  def floors
    # Anzahl Geschosse
    t('information.floors_value', :count => model.floors) if model.floors.present?
  end

  def ceiling_height
    # Raumhöhe
    t('information.ceiling_height_value', :size => model.ceiling_height) if model.ceiling_height.present?
  end

  def location_characteristics
    buffer = []

    points = model.points_of_interest.map {|p| p}

    transports = %w(public_transport highway_access).map {|name| points.find {|p| p.name == name && p.distance.present?} }.compact
    buffer << transports.map {|trans| t("information.points_of_interest.#{trans.name}", :distance => trans.distance) }.join(', ') if
      transports.length > 0

    schools =  %w(kindergarden elementary_school high_school).map {|name| points.find {|p| p.name == name && p.distance.present?} }.compact
    buffer << schools.map {|school| t("information.points_of_interest.#{school.name}", :distance => school.distance) }.join(', ') if
      schools.length > 0

    points.delete_if {|poi| schools.include?(poi) || transports.include?(poi) }
    points.each do |poi|
      if poi.distance.present?
        buffer << t("information.points_of_interest.#{poi.name}", :distance => poi.distance)
      end
    end

    buffer
  end
end
