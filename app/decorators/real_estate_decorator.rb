class RealEstateDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  decorates :real_estate

  def full_address
    [
      category.try(:label).presence,
      [
        address.try(:zip).presence,
        address.try(:city).presence,
        address.try(:canton).try(:upcase).presence
      ].join(' '),
      [
        address.try(:street).presence,
        address.try(:street_number).presence
      ].join(' '),
    ].join(tag('br')).html_safe
  end

  def quick_infos
    buffer = []

    if figure.rooms.present?
      buffer << t('real_estates.show.number_of_rooms', :count => figure.rooms)
    end

    if figure.floor.present?
      buffer << t('real_estates.show.floor', :number => figure.floor)
    end

    if figure.living_surface.present?
      buffer << t('real_estates.show.living_surface_html', :size => figure.living_surface)
    end

    buffer.join(tag('br')).html_safe
  end

  def description
    if model.description.present?
      markdown model.description
    end
  end

  def mini_doku_link
    link_to(
      t('real_estates.show.description_download'), 
      real_estate_path(model, :format => :pdf),
      :class => 'icon-description'
    )
  end

  def quick_price_infos
    buffer = []

    if model.for_rent? && model.pricing.try(:for_rent_netto).present?
      buffer << t('real_estates.show.for_rent')
      buffer << number_to_currency(model.pricing.for_rent_netto, :locale=>'de-CH')
    elsif model.for_sale? && model.pricing.try(:for_sale).present?
      buffer << t('real_estates.show.for_sale')
      buffer << number_to_currency(model.pricing.for_sale, :locale=>'de-CH')
    end

    buffer.join(tag('br')).html_safe
  end

  def price_info_basic
    buffer = []
    
    if model.for_rent?
      
      if model.pricing.try(:estimate).present?
        buffer << t('real_estates.show.for_rent_long', :price => model.pricing.estimate)
      elsif model.pricing.try(:for_rent_netto).present?
        buffer << t('real_estates.show.for_rent_long', :price => number_to_currency(model.pricing.for_rent_netto, :locale=>'de-CH'))
      end

      if model.pricing.try(:for_rent_extra).present?
        buffer << t('real_estates.show.for_rent_extra_long', :price => number_to_currency(model.pricing.for_rent_extra, :locale=>'de-CH'))
      end

    elsif model.for_sale? && model.pricing.try(:for_sale).present?

    end

    buffer
  end

  def price_info_parking
    buffer = []
    
    if model.pricing.try(:inside_parking).present?
      buffer << t('real_estates.show.inside_parking', :price => number_to_currency(model.pricing.inside_parking, :locale=>'de-CH'))
    end

    if model.pricing.try(:inside_parking_temporary).present?
      buffer << t('real_estates.show.inside_parking_temporary', :price => number_to_currency(model.pricing.inside_parking_temporary, :locale=>'de-CH'))
    end

    if model.pricing.try(:outside_parking).present?
      buffer << t('real_estates.show.outside_parking', :price => number_to_currency(model.pricing.outside_parking, :locale=>'de-CH'))
    end

    if model.pricing.try(:outside_parking_temporary).present?
      buffer << t('real_estates.show.outside_parking_temporary', :price => number_to_currency(model.pricing.outside_parking_temporary, :locale=>'de-CH'))
    end

    buffer
  end

  def facts_and_figures
    buffer = []

    if model.figure.try(:floor_estimate).present?
      buffer << t('real_estates.show.floor_estimate', :number => model.figure.floor_estimate)
    elsif model.figure.try(:floor).present?
      buffer << t('real_estates.show.floor_long', :number => model.figure.floor)
    end

    if model.figure.try(:floors).present?
      buffer << t('real_estates.show.floors', :number => model.figure.floors)
    end

    if model.figure.try(:rooms_estimate).present?
      buffer << t('real_estates.show.rooms_estimate', :number => model.figure.rooms_estimate)
    elsif model.figure.try(:rooms).present?
      buffer << t('real_estates.show.rooms', :number => model.figure.rooms)
    end

    if model.figure.try(:living_surface_estimate).present?
      buffer << t('real_estates.show.living_surface_estimate', :number => model.figure.living_surface_estimate)
    elsif model.figure.try(:living_surface).present?
      buffer << t('real_estates.show.living_surface', :number => model.figure.living_surface)
    end

    if model.figure.try(:property_surface).present?
      buffer << t('real_estates.show.property_surface', :number => model.figure.property_surface)
    end

    if model.figure.try(:usable_surface).present?
      buffer << t('real_estates.show.usable_surface', :number => model.figure.usable_surface)
    end

    if model.figure.try(:storage_surface).present?
      buffer << t('real_estates.show.storage_surface', :number => model.figure.storage_surface)
    end

    if model.figure.try(:ceiling_height).present?
      buffer << t('real_estates.show.ceiling_height', :number => model.figure.ceiling_height)
    end

    if model.figure.try(:renovated_on).present?
      buffer << t('real_estates.show.renovated_on', :number => model.figure.renovated_on)
    end

    if model.figure.try(:built_on).present?
      buffer << t('real_estates.show.built_on', :number => model.figure.built_on)
    end

    buffer
  end

  def infrastructure_parking
    buffer = []

    if model.infrastructure.try(:has_parking_spot).present?
      buffer << t('real_estates.show.has_parking_spot')
    end

    if model.infrastructure.try(:has_roofed_parking_spot).present?
      buffer << t('real_estates.show.has_roofed_parking_spot')
    end

    if model.infrastructure.try(:has_garage).present?
      buffer << t('real_estates.show.has_garage')
    end

    if model.infrastructure.try(:inside_parking_spots).present?
      buffer << t('real_estates.show.inside_parking_spots', :number => model.infrastructure.inside_parking_spots)
    end

    if model.infrastructure.try(:outside_parking_spots).present?
      buffer << t('real_estates.show.outside_parking_spots', :number => model.infrastructure.outside_parking_spots)
    end

    if model.infrastructure.try(:inside_parking_spots_temporary).present?
      buffer << t('real_estates.show.inside_parking_spots_temporary', :number => model.infrastructure.inside_parking_spots_temporary)
    end

    if model.infrastructure.try(:outside_parking_spots_temporary).present?
      buffer << t('real_estates.show.outside_parking_spots_temporary', :number => model.infrastructure.outside_parking_spots_temporary)
    end

    buffer
  end

  def infrastructure_distances
    buffer = []

    model.infrastructure.points_of_interest.each do |poi|
      if poi.distance.present?
        buffer << t("real_estates.show.#{poi.name}", :number => poi.distance)
      end
    end

    buffer
  end

end