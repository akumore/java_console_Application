class FigureDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :figure

  def surface_label
    if model.commercial_utilization?
      t "figures.surface.commercial"
    else
      t "figures.surface.private"
    end
  end

  def surface
    value = if model.commercial_utilization?
      usable_surface
    elsif model.private_utilization?
      living_surface
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

  def rooms
    if model.rooms_estimate.present?
      model.rooms_estimate
    elsif model.rooms.present?
      t('figures.rooms_value', :count => model.rooms)
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
    t('figures.surface_value', :size => model.storage_surface) if model.storage_surface.present?
  end

  def ceiling_height
    # Raumhöhe
    t('figures.ceiling_height_value', :size => model.ceiling_height) if model.ceiling_height.present?
  end

  def floors
    # Geschosse
    t('figures.floors_value', :count => model.floors) if model.floors.present?
  end

end
