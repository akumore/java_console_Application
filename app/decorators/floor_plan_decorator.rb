class FloorPlanDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :floor_plan, :class => MediaAssets::FloorPlan

  def zoom_link
    h.link_to I18n.t('.floorplan'), "#floorplan-zoomed-#{id}", :class => 'zoom-floorplan zoom-overlay'
  end

  def zoomed_div
    h.content_tag(:div, :class => "floorplan-zoomed", :id => "floorplan-zoomed-#{id}") do
      h.image_tag(floor_plan.file.url) + north_star_overlay
    end
  end

  def north_star_overlay
    if real_estate.additional_description.orientation_degrees.present?
      angle = real_estate.additional_description.orientation_degrees.to_i
      angle = angle - angle % 5
      h.tag(:div, { :class => "north-star-overlay north-star-#{angle}" })
    end
  end

end
