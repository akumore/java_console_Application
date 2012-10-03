module RealEstatesHelper

  def cantons_for_collection_select(cantons)
    cantons.map {|canton| [canton, t("cantons.#{canton}")]}
  end

  def offer_select_options
    [
      [t("real_estates.search_filter.for_rent"), RealEstate::OFFER_FOR_RENT],
      [t("real_estates.search_filter.for_sale"), RealEstate::OFFER_FOR_SALE]
    ]
  end

  def utilization_select_options
    [
      [t("real_estates.search_filter.private"), RealEstate::UTILIZATION_PRIVATE],
      [t("real_estates.search_filter.commercial"), RealEstate::UTILIZATION_COMMERICAL]
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
