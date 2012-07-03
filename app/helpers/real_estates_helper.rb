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

end
