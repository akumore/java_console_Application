class UnpublishNewsItemsWhenNotTranslated < Mongoid::Migration
  def self.up
    published_translations = HashWithIndifferentAccess.new Hash[I18n.available_locales.zip([false] * I18n.available_locales.count)]

    NewsItem.all.each do |item|
      item.update_attributes(published_translations: published_translations.merge(item.locale => true))
    end
  end

  def self.down
  end
end
