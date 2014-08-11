class InformationDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :information

  INFRASTRUCTURE_FIELDS = %w(built_on renovated_on floors has_swimming_pool is_child_friendly is_wheelchair_accessible
    is_minergie_style is_minergie_certified has_elevator has_ramp has_lifting_platform has_railway_terminal
    freight_elevator_carrying_capacity)

  def infrastructure_characteristics
    return [] if real_estate.parking?
    translate_characteristics(INFRASTRUCTURE_FIELDS)
  end

  INTERIOR_FIELDS = %w(has_sewage_supply has_water_supply has_balcony has_garden_seating has_fireplace has_isdn
    has_cable_tv maximal_floor_loading ceiling_height number_of_restrooms)

  def interior_characteristics
    return [] if real_estate.parking?
    translate_characteristics(INTERIOR_FIELDS)
  end

  def update_characteristics
    update_list_in(:location)
    update_list_in(:infrastructure)
    update_list_in(:interior)
  end

  def number_of_restrooms
    t('information.number_of_restrooms', :count => model.number_of_restrooms)
  end

  def maximal_floor_loading
    if model.maximal_floor_loading.present?
      t('information.maximal_floor_loading') + ': ' + t('information.maximal_floor_loading_value', :count => model.maximal_floor_loading )
    end
  end

  def freight_elevator_carrying_capacity
    if model.freight_elevator_carrying_capacity.present?
      t('information.freight_elevator_carrying_capacity') + ': ' + t('information.freight_elevator_carrying_capacity_value', :count => model.freight_elevator_carrying_capacity )
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
      if figure.surface.present?
        content << { :key => figure.surface_label, :value => figure.surface }
      end

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

    characteristics = infrastructure_characteristics + interior_characteristics
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

  def floors
    # Anzahl Geschosse
    t('information.floors_value', :count => model.floors) if model.floors.present?
  end

  def ceiling_height
    # Raumhöhe
    t('information.ceiling_height') + ': ' + t('information.ceiling_height_value', :size => model.ceiling_height) if model.ceiling_height.present?
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
