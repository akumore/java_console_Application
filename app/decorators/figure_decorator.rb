class FigureDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :figure

  OFFER_FIELDS = %w(inside_parking_spots outside_parking_spots covered_slot covered_bike
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
    value = if model.working?
      usable_surface
    elsif model.living?
      living_surface
    else
      usable_surface
    end
  end

  def specification_surface
    if model.working?
      if model.specification_usable_surface_toilet?
        model.specification_usable_surface_with_toilet
      else
        model.specification_usable_surface_without_toilet
      end
    elsif model.living?
      model.specification_living_surface
    elsif model.storing?
      model.specification_usable_surface
    end
  end

  def floor
    if model.floor_estimate.present?
      model.floor_estimate
    elsif model.floor.present?
      if model.floor < 0
        t('figures.lower_floor', :floor => model.floor * -1)
      elsif model.floor == 0
        t('figures.ground_floor')
      elsif model.floor > 0
        t('figures.upper_floor', :floor => model.floor)
      end
    end
  end

  def shortened_floor
    if model.floor.present?
      if model.floor < 0
        "#{model.floor.abs}. UG"
      elsif model.floor > 0
        "#{model.floor}. OG"
      elsif model.floor == 0
        'EG'
      end
    end
  end

  def rooms
    if model.rooms_estimate.present?
      model.rooms_estimate
    elsif model.rooms.present? && '0' != model.rooms
      t('figures.rooms_value', :count => model.rooms)
    else
      ''
    end
  end

  def living_surface
    if model.living_surface_estimate.present?
      model.living_surface_estimate
    elsif model.living_surface.present?
      t('figures.surface_value', :size => model.living_surface)
    end
  end

  def usable_surface
    if model.usable_surface_estimate.present?
      model.usable_surface_estimate
    elsif model.usable_surface.present?
      t('figures.surface_value', :size => model.usable_surface)
    end
  end

  def property_surface
    # Grundstückfläche
    if model.property_surface_estimate.present?
      model.property_surface_estimate
    elsif model.property_surface.present?
      t('figures.surface_value', :size => model.property_surface)
    end
  end

  def storage_surface
    # Lagerfläche
    if model.storage_surface_estimate.present?
      t('figures.surface_value', :size => model.storage_surface_estimate)
    elsif model.storage_surface.present?
      t('figures.surface_value', :size => model.storage_surface)
    end
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
