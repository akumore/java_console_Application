class FigureDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :figure

  OFFER_FIELDS = %w(rooms long_surface long_property_surface long_storage_surface
                    inside_parking_spots outside_parking_spots covered_slot covered_bike
                    outdoor_bike single_garage double_garage)

  def offer_characteristics
    translate_characteristics(OFFER_FIELDS)
  end

  def update_characteristics
    update_list_in(:offer)
  end

  def surface_label
    if model.living?
      t "figures.surface.private"
    else
      t "figures.surface.commercial"
    end
  end

  def surface
    return usable_surface if model.working?
    return living_surface if model.living?
    usable_surface
  end

  def long_surface
    surface_label + ' ' + surface if surface.present?
  end

  def specification_surface
    if model.working?
      if model.specification_usable_surface_toilet?
        return model.specification_usable_surface_with_toilet
      else
        return model.specification_usable_surface_without_toilet
      end
    end

    return model.specification_living_surface if model.living?
    return model.specification_usable_surface if model.storing?
  end

  def floor
    return model.floor_estimate if model.floor_estimate.present?

    return unless model.floor.present?

    if model.floor < 0
      t('figures.lower_floor', :floor => model.floor * -1)
    elsif model.floor == 0
      t('figures.ground_floor')
    elsif model.floor > 0
      t('figures.upper_floor', :floor => model.floor)
    end
  end

  def shortened_floor
    return unless model.floor.present?

    if model.floor < 0
      "#{model.floor.abs}. UG"
    elsif model.floor > 0
      "#{model.floor}. OG"
    elsif model.floor == 0
      'EG'
    end
  end

  def rooms
    return model.rooms_estimate if model.rooms_estimate.present?
    return t('figures.rooms_value', :count => model.rooms) if model.rooms.present? && '0' != model.rooms
    ''
  end

  def living_surface
    return unless field_access.accessible?(model, :living_surface)
    return model.living_surface_estimate if model.living_surface_estimate.present?
    t('figures.surface_value', :size => model.living_surface) if model.living_surface.present?
  end

  def usable_surface
    return unless field_access.accessible?(model, :usable_surface)
    return model.usable_surface_estimate if model.usable_surface_estimate.present?
    t('figures.surface_value', :size => model.usable_surface) if model.usable_surface.present?
  end

  def property_surface
    return unless field_access.accessible?(model, :property_surface)
    # Grundstückfläche
    return model.property_surface_estimate if model.property_surface_estimate.present?
    t('figures.surface_value', :size => model.property_surface) if model.property_surface.present?
  end

  def long_property_surface
    t('figures.property_surface') + ' ' + property_surface if property_surface.present?
  end

  def storage_surface
    return unless field_access.accessible?(model, :storage_surface)
    # Lagerfläche
    if model.storage_surface_estimate.present?
      t('figures.surface_value', :size => model.storage_surface_estimate)
    elsif model.storage_surface.present?
      t('figures.surface_value', :size => model.storage_surface)
    end
  end

  def long_storage_surface
    t('figures.storage_surface') + ' ' + storage_surface if storage_surface.present?
  end

  def chapter
    content = []
    if figure.inside_parking_spots.present?
      content << {
        :key => t('figures.inside_parking_spots', :count => figure.inside_parking_spots),
        :value => figure.inside_parking_spots
      }
    end

    if figure.outside_parking_spots.present?
      content << {
        :key => t('figures.outside_parking_spots', :count => figure.outside_parking_spots),
        :value => figure.outside_parking_spots
      }
    end

    if figure.covered_slot.present?
      content << {
        :key => t('figures.covered_slot', :count => figure.covered_slot),
        :value => figure.covered_slot
      }
    end

    if figure.covered_bike.present?
      content << {
        :key => t('figures.covered_bike', :count => figure.covered_bike),
        :value => figure.covered_bike
      }
    end

    if figure.outdoor_bike.present?
      content << {
        :key => t('figures.outdoor_bike', :count => figure.outdoor_bike),
        :value => figure.outdoor_bike
      }
    end

    if figure.single_garage.present?
      content << {
        :key => t('figures.single_garage', :count => figure.single_garage),
        :value => figure.single_garage
      }
    end

    if figure.double_garage.present?
      content << {
        :key => t('figures.double_garage', :count => figure.double_garage),
        :value => figure.double_garage
      }
    end

    {
      :title => t('figures.title'),
      :collapsible => true,
      :content => content
    }
  end
end
