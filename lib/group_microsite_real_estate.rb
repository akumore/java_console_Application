# encoding: utf-8

class GroupMicrositeRealEstates

  def self.get_group(real_estate)
    if real_estate.commercial_utilization? then
      return 'Dienstleistungsflächen'
    elsif real_estate.category_label == 'Loft'
      return real_estate.category_label
    end

    figure = real_estate.figure
    if figure.present? && figure.rooms.present?
      return "#{figure.rooms} Zimmer Wohnungen"
    end

  end

end
