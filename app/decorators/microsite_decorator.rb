# encoding: utf-8

require 'microsite/group_real_estate'
require 'microsite/sort_real_estate'
require 'microsite/assemble_real_estate_chapters'

class MicrositeDecorator < ApplicationDecorator

  include Draper::LazyHelpers

  decorates :real_estate
  allows '_id', :rooms, :floor_label, :house, :surface, :price

  GARTENSTADT_STREET = 'Badenerstrasse'
  STREET_NUMBER_HOUSE_MAP = {
    '26' => 'M',
    '28' => 'L',
    '30' => 'K',
    '32' => 'I',
    '34' => 'H',
  }

  FLOOR_FLOOR_LABEL_MAP = {
    -1 => 'UG',
    0  => 'EG',
    1  => '1.OG',
    2  => '2.OG',
    3  => '3.OG',
    4  => '4.OG',
  }

  def rooms
    if real_estate.figure.present?
      real_estate.figure.rooms
    else
      return nil
    end
  end

  def floor_label
    figure = real_estate.figure
    if figure.present?
      return FLOOR_FLOOR_LABEL_MAP[figure.floor]
    else
      return nil
    end
  end

  def house
    address = real_estate.address
    if address.present? and address.street == GARTENSTADT_STREET then
      return STREET_NUMBER_HOUSE_MAP[address.street_number]
    else
      return nil
    end
  end

  def surface
    figure = real_estate.figure
    if figure.present? && figure.private_utilization? && figure.living_surface.present? then
      return "#{figure.living_surface}m²"
    elsif figure.present? && figure.commercial_utilization? && figure.usable_surface.present? then
      return "#{figure.usable_surface}m²"
    else
      return nil
    end
  end

  def price
    net_price = real_estate.pricing && real_estate.pricing.for_rent_netto
    if net_price.present?
      return "CHF #{net_price}"
    else
      return nil
    end
  end

  def group
    g = Microsite::GroupRealEstates.get_group(real_estate)
    g && g[:label]
  end

  def group_sort_key
    g = Microsite::GroupRealEstates.get_group(real_estate)
    g && g[:sort_key]
  end

  def chapters
    Microsite::AssembleRealEstateChapters.get_chapters(real_estate)
  end

  def as_json(options = {})
    json = real_estate.as_json options.merge({ :only => [ :_id ] })
    json['rooms']       = rooms()
    json['floor_label'] = floor_label()
    json['house']       = house()
    json['surface']     = surface()
    json['price']       = price()
    json['group']       = group()
    json['chapters']    = chapters()
    json
  end

  def <=>(otherRealEstate)
    Microsite::SortRealEstates.sort(self, otherRealEstate)
  end

end

