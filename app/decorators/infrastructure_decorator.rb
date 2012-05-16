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

    if infrastructure.inside_parking_spots_temporary.present?
      content << {
        :key => t('infrastructures.inside_parking_spots_temporary', :count => infrastructure.inside_parking_spots_temporary),
        :value => infrastructure.inside_parking_spots_temporary
      }
    end

    if infrastructure.outside_parking_spots_temporary.present?
      content << {
        :key => t('infrastructures.outside_parking_spots_temporary', :count => infrastructure.outside_parking_spots_temporary),
        :value => infrastructure.outside_parking_spots_temporary
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
