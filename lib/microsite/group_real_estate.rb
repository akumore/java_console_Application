# encoding: utf-8

module Microsite
  class GroupRealEstates

    def self.get_group(real_estate)
      if real_estate.commercial_utilization?
        label = 'Dienstleistungsflächen'
        sort_key = 'B'
      elsif real_estate.category_label == 'Loft'
        label = real_estate.category_label
        sort_key = 'A'
      elsif real_estate.storing?
        label = real_estate.category_label
        sort_key = 'D'
      else
        figure = real_estate.figure
        if figure.present? && figure.rooms.present?
          if figure.rooms != '0'
            label = "#{figure.rooms} Zimmer"
            sort_key = figure.rooms
          else
            label = 'Wohnatelier'
            sort_key = 'C'
          end
        end
      end

      { :label => label, :sort_key => sort_key }

    end

  end
end
