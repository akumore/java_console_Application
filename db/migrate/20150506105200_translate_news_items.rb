class TranslateNewsItems < Mongoid::Migration
  def self.up
    @locales = I18n.available_locales

    NewsItem.all.each do |item|
      I18n.with_locale item.locale do
        @title_root_translation     = item.title_translations
        @content_root_translation   = item.content_translations
        @published_root_translation = item.published_translations
      end

      item.title_translations     = Hash[@locales.collect { |locale| [locale, @title_root_translation] }]
      item.content_translations   = Hash[@locales.collect { |locale| [locale, @content_root_translation] }]
      item.published_translations = Hash[@locales.collect { |locale| [locale, @published_root_translation] }]
      item.save!
    end
  end

  def self.down
  end
end
