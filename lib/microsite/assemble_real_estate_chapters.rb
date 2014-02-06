# encoding: utf-8
require 'field_access'

module Microsite
  class AssembleRealEstateChapters

    def self.get_chapters(real_estate)
      chapters = []

      field_access = FieldAccess.new(real_estate.offer, real_estate.utilization, FieldAccess.cms_blacklist)

      if real_estate.information.present?
        information_chapter = InformationDecorator.decorate(real_estate.information, context: {field_access: field_access}).chapter
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

      if real_estate.figure.present?
        figure_chapter = FigureDecorator.decorate(real_estate.figure).chapter
        unless figure_chapter[:content].blank? and figure_chapter[:content_html].blank?
          chapters << figure_chapter
        end
      end
      chapters
    end

  end

end

