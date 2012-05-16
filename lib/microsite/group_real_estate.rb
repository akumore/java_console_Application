# encoding: utf-8

module Microsite
  class GroupRealEstates

    def self.get_group(real_estate)
      if real_estate.commercial_utilization? then
        label = 'Dienstleistungsflächen'
        sort_key = 'A'
      elsif real_estate.category_label == 'Loft'
        label = real_estate.category_label
        sort_key = 'B'
      else
        figure = real_estate.figure
        if figure.present? && figure.rooms.present?
          label = "#{figure.rooms} Zimmer Wohnungen"
          sort_key = figure.rooms
        end
      end

      { :label => label, :sort_key => sort_key }

    end

  end
end
