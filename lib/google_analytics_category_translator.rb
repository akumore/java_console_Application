module GoogleAnalyticsCategoryTranslator

  def translate_category(real_estate)
    "#{I18n.t("real_estates.search_filter.#{real_estate.offer}", locale: :de)} #{I18n.t("real_estates.search_filter.#{real_estate.utilization}", locale: :de)}"
  end
end
