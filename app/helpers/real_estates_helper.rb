module RealEstatesHelper

  def cantons_for_collection_select(cantons)
    cantons.map {|canton| [canton, t("cantons.#{canton}")]}
  end

  def offer_select_options
    [
      [t("real_estates.search_filter.for_rent"), Offer::RENT],
      [t("real_estates.search_filter.for_sale"), Offer::SALE]
    ]
  end

  def utilization_select_options
    [
      [t("real_estates.search_filter.living"), Utilization::LIVING],
      [t("real_estates.search_filter.working"), Utilization::WORKING],
      [t("real_estates.search_filter.storing"), Utilization::STORING],
      [t("real_estates.search_filter.parking"), Utilization::PARKING]
    ]
  end

  def zoomed_div(floorplan, &block)
    content_tag :div, :class => "floorplan-zoomed", :id => "floorplan-zoomed-#{floorplan.id}" do
      block.call
    end
  end

  def caption_css_class_for_text(text)
    text.length > 25 ? 'flex-caption wide' : 'flex-caption'
  end

end
