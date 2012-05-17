# encoding: utf-8

module Microsite
  class AssembleRealEstateChapters

    def self.get_chapters(real_estate)
      chapters = []
      if real_estate.pricing.present?
        pricing_chapter = PricingDecorator.decorate(real_estate.pricing).chapter
        unless pricing_chapter[:content].blank? and pricing_chapter[:content_html].blank?
          chapters << pricing_chapter
        end
      end

      if real_estate.infrastructure.present?
        infrastructure_chapter = InfrastructureDecorator.decorate(real_estate.infrastructure).chapter
        unless infrastructure_chapter[:content].blank? and infrastructure_chapter[:content_html].blank?
          chapters << infrastructure_chapter
        end
      end
      chapters
    end

  end

end
