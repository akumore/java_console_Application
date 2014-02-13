module MediaAssets
  class FloorPlanDecorator < ApplicationDecorator
    include Draper::LazyHelpers

    decorates :floor_plan, :class => MediaAssets::FloorPlan
    decorates_association :real_estate

    def zoom_link
      h.link_to I18n.t('real_estates.show.floorplan'), real_estate_floorplan_path(floor_plan.real_estate, floor_plan),
        :class => 'zoom-floorplan zoom-overlay', :target => '_blank', 'data-zoomed-content' => "#floorplan-zoomed-#{id}"
    end

    def north_arrow_overlay
      if orientation_degrees.present?
        h.content_tag(:div, :class => "north-arrow-container") do
          north_arrow_img_tag
        end
      end
    end

    def north_arrow_img_tag
      img = north_arrow_img
      if north_arrow_img.present?
        h.image_tag(img, :class => 'north-arrow')
      end
    end

    def north_arrow_img
      if orientation_degrees.present?
        angle = orientation_degrees.to_i
        angle = angle - angle % 5
        "north-arrow/#{angle}.png"
      end
    end
  end
end
