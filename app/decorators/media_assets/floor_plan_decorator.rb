module MediaAssets
  class FloorPlanDecorator < ApplicationDecorator
    include Draper::LazyHelpers

    decorates :floor_plan, :class => MediaAssets::FloorPlan
    decorates_association :real_estate

    def zoom_link
      h.link_to I18n.t('real_estates.show.floorplan'), real_estate_floorplan_path(floor_plan.real_estate, floor_plan),
        :class => 'zoom-floorplan zoom-overlay', :target => '_blank', 'data-zoomed-content' => "#floorplan-zoomed-#{id}"
    end

    def zoomed_div
      h.content_tag(:div, :class => "floorplan-zoomed",
                    :id => "floorplan-zoomed-#{id}") do
        h.image_tag(floor_plan.file.url) + real_estate.north_arrow_overlay
      end
    end

  end
end
