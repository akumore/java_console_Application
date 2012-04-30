class InfrastructureDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :infrastructure

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
