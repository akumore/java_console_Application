class FigureDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :figure

  def surface
    value = if model.commercial_utilization?
      model.usable_surface.presence
    elsif model.private_utilization?
      model.living_surface.presence
    end

    t('real_estates.show.surface', :size => value) if value.present?
  end
end
