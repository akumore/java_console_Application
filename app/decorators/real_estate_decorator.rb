class RealEstateDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :real_estate
  decorates_association :contact
  decorates_association :address
  decorates_association :information

  def google_maps_address
    [
      address.try(:street).presence, address.try(:street_number).presence,
      address.try(:zip).presence,
      address.try(:city).presence,
      address.try(:canton).try(:upcase).presence
    ].join(' ')
  end

  def short_info_address
    [address.try(:street).presence, address.try(:extended_city).presence].join(tag('br')).html_safe
  end

  def short_info_price
    buffer = []
    buffer << category.try(:label).presence

    if model.for_rent? && model.pricing.try(:for_rent_netto).present?
      buffer << number_to_currency(model.pricing.for_rent_netto, :locale=>'de-CH')
    elsif model.for_sale? && model.pricing.try(:for_sale).present?
      buffer << number_to_currency(model.pricing.for_sale, :locale=>'de-CH')
    end

    buffer.join(tag('br')).html_safe
  end

  def short_info_figure
    buffer = []

    if figure.try(:rooms).present?
      buffer << t('real_estates.show.number_of_rooms', :count => figure.rooms)
    end

    if figure.try(:floor).present?
      buffer << t('real_estates.show.floor', :number => figure.floor)
    end

    buffer.join(tag('br')).html_safe
  end

  def short_info_size
    buffer = []

    if figure.try(:living_surface).present?
      buffer << t('real_estates.show.living_surface_html', :size => figure.living_surface)
    end

    if information.try(:available_from).present?
      buffer << information.available_from
    end

    buffer.join(tag('br')).html_safe
  end

  def reference_project_caption

    if address && address.link_url.present?
      link = real_estate.address.link_url
    elsif channels.include?(RealEstate::WEBSITE_CHANNEL) && channels.include?(RealEstate::REFERENCE_PROJECT_CHANNEL)
      link = h.real_estate_path(model)
    end

    buffer = []
    buffer << h.content_tag(:h3, real_estate.title)
    buffer << h.content_tag(:div, link_to(t('real_estates.reference_projects.link_title'), link)) if link.present?
    buffer.join.html_safe
  end

  def description
    if model.description.present?
      markdown model.description
    end
  end

  def mini_doku_link
    link_to(
        t('real_estates.show.description_download'),
        real_estate_handout_path(:real_estate_id => model.id, :format => :pdf),
        :class => 'icon-description'
    ) if model.has_handout?
  end

  def floorplan_link
    if model.media_assets.floorplans.exists?
      link_to t('real_estates.show.floorplan'), '#', :class => 'icon-groundplan'
    end
  end

  def information_shared
    buffer = []

    if information.try(:available_from).present?
      buffer << information.available_from
    end

    if information.try(:is_new_building) == true
      buffer << t('real_estates.show.is_new_building')
    elsif information.try(:is_old_building) == true
      buffer << t('real_estates.show.is_old_building')
    end

    if information.try(:is_minergie_style) == true
      buffer << t('real_estates.show.is_minergie_style')
    end

    if information.try(:is_minergie_certified) == true
      buffer << t('real_estates.show.is_minergie_certified')
    end

    buffer
  end

  def information_basic
    buffer = []

    [
      :has_outlook,
      :has_fireplace,
      :has_elevator,
      :has_isdn,
      :is_wheelchair_accessible,
      :is_child_friendly,
      :has_balcony,
      :has_raised_ground_floor,
      :has_swimming_pool
    ].each do |key|
      if information.try(key) == true
        buffer << t("real_estates.show.#{key}")
      end
    end

    [
      :has_ramp,
      :has_lifting_platform,
      :has_railway_terminal,
      :has_water_supply,
      :has_sewage_supply,
      :is_developed,
      :is_under_building_laws
    ].each do |key|
      if information.try(key) == true
        buffer << t("real_estates.show.#{key}")
      end
    end

    if information.try(:maximal_floor_loading).present?
      buffer << t('real_estates.show.maximal_floor_loading', :number => information.maximal_floor_loading)
    end

    if information.try(:freight_elevator_carrying_capacity).present?
      buffer << t('real_estates.show.freight_elevator_carrying_capacity', :number => information.freight_elevator_carrying_capacity)
    end

    if information.try(:number_of_restrooms).present?
      buffer << t('real_estates.show.number_of_restrooms', :number => information.number_of_restrooms)
    end

    buffer
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

    if model.infrastructure.present?
      model.infrastructure.points_of_interest.each do |poi|
        if poi.distance.present?
          buffer << t("real_estates.show.#{poi.name}", :number => poi.distance)
        end
      end
    end

    buffer
  end

end
