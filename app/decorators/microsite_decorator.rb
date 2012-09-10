# encoding: utf-8

require 'microsite/group_real_estate'
require 'microsite/assemble_real_estate_chapters'

class MicrositeDecorator < ApplicationDecorator

  include Draper::LazyHelpers

  decorates :real_estate
  allows '_id', :rooms, :floor_label, :house, :surface, :price, :private_utilization?, :figure

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
    1  => '1. OG',
    2  => '2. OG',
    3  => '3. OG',
    4  => '4. OG',
  }

  def title
    real_estate.title
  end

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
    if address.present? and address.street.try(:strip) == GARTENSTADT_STREET then
      return STREET_NUMBER_HOUSE_MAP[address.street_number]
    else
      return nil
    end
  end

  def surface
    "#{surface_value} m²" if surface_value.present?
  end

  def surface_value
    private_utilization? ? figure.living_surface.presence : figure.usable_surface.presence
  end

  def price
    PricingDecorator.decorate(real_estate.pricing).for_rent_netto if real_estate.pricing.present?
  end

  def group
    g = Microsite::GroupRealEstates.get_group(real_estate)
    g && g[:label]
  end

  def utilization
    h.t("real_estates.search_filter.#{model.utilization}")
  end

  def category
    model.category_label
  end

  def group_sort_key
    g = Microsite::GroupRealEstates.get_group(real_estate)
    g && g[:sort_key]
  end

  def chapters
    Microsite::AssembleRealEstateChapters.get_chapters(real_estate)
  end

  def floorplans
    real_estate.floor_plans.collect do |asset|
      attributes = {
        :url => path_to_url(asset.file.gallery.url),
        :url_full_size => path_to_url(real_estate_floorplan_path(I18n.locale, real_estate, asset)),
        :url_full_size_image => path_to_url(asset.file.url),
        :title => asset.title,
      }
      north_arrow_img = RealEstateDecorator.decorate(asset.real_estate).north_arrow_img
      attributes[:north_arrow] = path_to_url(image_path(north_arrow_img)) if north_arrow_img.present?
      attributes
    end
  end

  def images
    real_estate.images.collect do |asset|
      attrs = {
        :url => path_to_url(asset.file.gallery.url),
        :title => asset.title,
      }
    end
  end

  def downloads
    dl = []
    dl << {
            :title => t('real_estates.show.description_download'),
            :url => path_to_url(real_estate_handout_path(
              :real_estate_id => model.id,
              :format => :pdf,
              :name => "Objektdokumentation-#{model.title.parameterize}",
              :locale => I18n.locale
              ))
    } if model.has_handout?

    if model.for_rent?
      link = if model.private_utilization?
        '/documents/Anmeldeformular-Mieten-Wohnen.pdf'
      elsif model.commercial_utilization?
        '/documents/Anmeldeformular-Mieten-Gewerbe.pdf'
      end

      dl << {
        :title => t('real_estates.show.application_form'),
        :url => path_to_url(link)
      }
    end

  end

  def as_json(options = {})
    options ||= {}
    json = real_estate.as_json options.merge({ :only => [ :_id ] })
    json['title']       = title()
    json['rooms']       = rooms()
    json['floor_label'] = floor_label()
    json['house']       = house()
    json['surface']     = surface()
    json['price']       = price()
    json['group']       = group()
    json['utilization'] = utilization()
    json['category']    = category()
    json['chapters']    = chapters()
    json['floorplans']  = floorplans()
    json['images']      = images()
    json['downloads']   = downloads()
    json
  end

  def <=>(other)
    return group_sort_key <=> other.group_sort_key if group_sort_key != other.group_sort_key
    return house <=> other.house if house != other.house
    return surface_value <=> other.surface_value if surface_value != other.surface_value
    return figure.floor <=> other.figure.floor if figure.floor != other.figure.floor
    0
  end

end

