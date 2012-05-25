module MediaAssets
  class FloorPlanDecorator < ApplicationDecorator
    include Draper::LazyHelpers

    decorates :floor_plan, :class => MediaAssets::FloorPlan
    decorates_association :real_estate

    def zoom_link
      h.link_to I18n.t('.floorplan'), "#floorplan-zoomed-#{id}",
        :class => 'zoom-floorplan zoom-overlay'
    end

    def zoomed_div
      h.content_tag(:div, :class => "floorplan-zoomed",
                    :id => "floorplan-zoomed-#{id}") do
        h.image_tag(floor_plan.file.url) + real_estate.north_arrow_overlay
      end
    end

  end
end
