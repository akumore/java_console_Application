class MicrositeDecorator < ApplicationDecorator

  include Draper::LazyHelpers

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

  decorates :real_estate

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
    
  end

  def price
    net_price = real_estate.pricing && real_estate.pricing.for_rent_netto
    if net_price.nil?
      return nil
    else
      return "CHF #{net_price}"
    end
  end
end
