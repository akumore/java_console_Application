module GoogleAnalyticsCategoryTranslator

  def translate_category(real_estate)
    "#{t("real_estates.search_filter.#{real_estate.offer}", locale: :de)} #{t("real_estates.search_filter.#{real_estate.utilization}", locale: :de)}"
  end
end
