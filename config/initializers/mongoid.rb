I18n.available_locales.each do |locale|
  Mongoid.add_language(locale)
end