class TranslateNewsItems < Mongoid::Migration
  def self.up
    NewsItem.all.each do |item|
      I18n.with_locale item.locale do
        item.title_translations     = { I18n.locale.to_s => item.title_translations }
        item.content_translations   = { I18n.locale.to_s => item.content_translations }
        item.published_translations = { I18n.locale.to_s => item.published_translations }
        item.save!
      end
    end
  end

  def self.down
  end
end
