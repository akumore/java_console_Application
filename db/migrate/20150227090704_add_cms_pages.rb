class AddCmsPages < Mongoid::Migration
  def self.up
    I18n.available_locales.each do |locale|
      [
        ['reference_projects', 'Referenzen'],
        ['real_estates', 'Angebot']
      ].each do |page|
        Page.find_or_create_by(name: page[0], locale: locale, title: page[1])
      end
    end
  end

  def self.down
    I18n.available_locales.each do |locale|
      ['reference_projects', 'real_estates'].each do |page|
        page = Page.where(name: page, locale: locale)
        page.destroy if page.present?
      end
    end
  end
end
