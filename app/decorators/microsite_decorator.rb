# encoding: utf-8
#
require 'group_microsite_real_estate'

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
    real_estate.figure.rooms
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
    if figure.private_utilization? && figure.living_surface.present? then
      return "#{figure.living_surface}m²"
    elsif figure.commercial_utilization? && figure.usable_surface.present? then
      return "#{figure.usable_surface}m²"
    else
      return nil
    end
  end

  def price
    net_price = real_estate.pricing && real_estate.pricing.for_rent_netto
    if net_price.nil?
      return nil
    else
      return "CHF #{net_price}"
    end
  end

  def group
    GroupMicrositeRealEstates.get_group real_estate
  end

  def as_json(options = {})
    json = real_estate.as_json options.merge({ :only => [ :_id ] })
    json['rooms']       = rooms()
    json['floor_label'] = floor_label()
    json['house']       = house()
    json['surface']     = surface()
    json['price']       = price()
    json['group']       = group()
    json
  end

end
