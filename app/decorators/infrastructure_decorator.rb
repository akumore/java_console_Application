class InfrastructureDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :infrastructure

  def chapter
    content = []
    if infrastructure.inside_parking_spots.present?
      content << {
        :key => t('infrastructures.inside_parking_spots', :count => infrastructure.inside_parking_spots),
        :value => infrastructure.inside_parking_spots
      }
    end

    if infrastructure.outside_parking_spots.present?
      content << {
        :key => t('infrastructures.outside_parking_spots', :count => infrastructure.outside_parking_spots),
        :value => infrastructure.outside_parking_spots
      }
    end

    if infrastructure.covered_slot.present?
      content << {
        :key => t('infrastructures.covered_slot', :count => infrastructure.covered_slot),
        :value => infrastructure.covered_slot
      }
    end

    if infrastructure.covered_bike.present?
      content << {
        :key => t('infrastructures.covered_bike', :count => infrastructure.covered_bike),
        :value => infrastructure.covered_bike
      }
    end

    if infrastructure.outdoor_bike.present?
      content << {
        :key => t('infrastructures.outdoor_bike', :count => infrastructure.outdoor_bike),
        :value => infrastructure.outdoor_bike
      }
    end

    if infrastructure.single_garage.present?
      content << {
        :key => t('infrastructures.single_garage', :count => infrastructure.single_garage),
        :value => infrastructure.single_garage
      }
    end

    if infrastructure.double_garage.present?
      content << {
        :key => t('infrastructures.double_garage', :count => infrastructure.double_garage),
        :value => infrastructure.double_garage
      }
    end

    if distances.any?
      content << {
        :key => t('infrastructures.distances'),
        :value => distances.join(', ')
      }
    end

    {
      :title => t('infrastructures.title'),
      :collapsible => true,
      :content => content
    }
  end

  def distances
    buffer = []

    model.points_of_interest.each do |poi|
      if poi.distance.present?
        buffer << t("infrastructures.points_of_interest.#{poi.name}", :distance => poi.distance)
      end
    end

    buffer
  end

end
