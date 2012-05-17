# encoding: utf-8

module Microsite
  class AssembleRealEstateChapters

    def self.get_chapters(real_estate)
      chapters = []
      description_chapter = DescriptionDecorator.decorate(real_estate).chapter
      unless description_chapter[:content].blank? and description_chapter[:content_html].blank?
        chapters << description_chapter
      end

      if real_estate.information.present?
        information_chapter = InformationDecorator.decorate(real_estate.information).chapter
        unless information_chapter[:content].blank? and information_chapter[:content_html].blank?
          chapters << information_chapter
        end
      end

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

