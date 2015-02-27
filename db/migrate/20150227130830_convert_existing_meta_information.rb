# encoding: utf-8
#
class ConvertExistingMetaInformation < Mongoid::Migration
  def self.up
    {
      jobs: { title: "Jobs - Bauleiter, Projektleiter, Immobilienverwalter, Immobilienbewirtschafter, Immobilienberater", description: "Wir sind ein Familienunternehmen, das den Menschen mit Wertschätzung begegnet. Mitarbeitende, Kunden und Partner stehen im Zentrum unserer Tätigkeit. Unseren Mitarbeitenden bieten wir ein kollegiales und förderndes Arbeitsklima. Dazu gehört, dass wir ihnen herausfordernde Aufgaben übertragen und das nötige Vertrauen schenken, damit sie ihre Aufgaben unternehmerisch erfüllen können." },
      company: { title: "Unternehmen - Projektentwicklung, Baurealisierung, Vermarktung, Bewirtschaftung, Umbau und Renovation", description: "Wir bieten unseren Kunden reibungsloses Projektmanagement an. Qualität, Seriosität und Fairness stehen bei der Alfred Müller AG an oberster Stelle – deshalb ist sie für ihre Kunden in jedem Moment eine zuverlässige Partnerin." },
      contact: { title: "Kontakt - Alfred Müller Immobilien", description: "Für alle Ihre Immobilienfragen haben wir eine Antwort. Nehmen Sie mit uns Kontakt auf." }
    }.each do |key, value|
      page = Page.where(name: key, locale: :de).first
      page.update_attributes(seo_title: value[:title], seo_description: value[:description]) if page.present?
    end
  end

  def self.down
    [
     'jobs',
     'company',
     'contact',
    ].each do |page|
      page = Page.where(name: page, locale: :de).first
      page.update_attributes(seo_title: "", seo_description: "") if page.present?
    end
  end
end
