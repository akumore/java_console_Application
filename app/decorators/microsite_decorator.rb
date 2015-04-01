# encoding: utf-8

require 'microsite/group_real_estate'
require 'microsite/assemble_real_estate_chapters'

class MicrositeDecorator < ApplicationDecorator

  include Draper::LazyHelpers

  decorates :real_estate
  allows '_id',
    :rooms,
    :floor_label,
    :house,
    :property_key,
    :building_key,
    :surface,
    :price,
    :private_utilization?,
    :figure

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
      return_floor_label(figure.floor)
    else
      return nil
    end
  end

  def return_floor_label(floor)
    if floor == -1
      'UG'
    elsif floor == 0
      'EG'
    elsif floor < 0
      "#{floor.abs}. UG"
    else
      "#{floor}. OG"
    end
  end

  def property_key
    real_estate.try(:microsite_reference).try(:property_key)
  end

  def building_key
    real_estate.try(:microsite_reference).try(:building_key)
  end

  def surface
    "#{surface_value} m²" if surface_value.present?
  end

  def surface_value
    private_utilization? ? figure.living_surface.presence : figure.usable_surface.presence
  end

  def price
    if real_estate.pricing.present?
      price_value = PricingDecorator.decorate(real_estate.pricing).for_rent_netto if real_estate.pricing.present?
      price_unit = PricingDecorator.decorate(real_estate.pricing).price_unit
      t("pricings.decorator.price_units.#{price_unit}", price: price_value)
    end
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
        url: path_to_url(asset.file.gallery.url),
        url_full_size: path_to_url(real_estate_floorplan_path(I18n.locale, real_estate, asset)),
        url_full_size_image: path_to_url(asset.file.url),
        title: asset.title,
      }
      north_arrow_img = MediaAssets::FloorPlanDecorator.decorate(asset).north_arrow_img
      attributes[:north_arrow] = path_to_url(image_path(north_arrow_img)) if north_arrow_img.present?
      attributes
    end
  end

  def images
    real_estate.images.collect do |asset|
      attrs = {
        url: path_to_url(asset.file.gallery.url),
        title: asset.title,
      }
    end
  end

  def downloads
    dl = []
    dl << {
            title: t('real_estates.show.description_download'),
            url: path_to_url(Rails.application.routes.url_helpers.real_estate_printout_path(
              real_estate_id: model.id,
              format: :pdf,
              name: model.handout.filename,
              locale: I18n.locale
              ))
    } if model.has_handout?

    if model.for_rent?
      link = if model.private_utilization?
        '/documents/de/Anmeldeformular-Mieten-Wohnen.pdf'
      else
        '/documents/de/Anmeldeformular-Mieten-Gewerbe.pdf'
      end

      dl << {
        title: t('real_estates.show.application_form'),
        url: path_to_url(link)
      }
    end
  end

  def documents
    model.documents.collect do |doc|
      attrs = {
        title: doc.title,
        url: path_to_url(doc.file.url)
      }
    end
  end

  def as_json(options = {})
    options ||= {}
    json = real_estate.as_json options.merge({ only: [ :_id ] })
    json['title']       = title()
    json['rooms']       = rooms()
    json['floor_label'] = floor_label()
    # DEPRECATED: house
    # house falls back to building_key
    # Used for backward compatibility with Gartenstadt
    json['house']       = building_key()
    json['building_key']= building_key()
    json['property_key']= property_key()
    json['surface']     = surface()
    json['price']       = price()
    json['group']       = group()
    json['utilization'] = utilization()
    json['category']    = category()
    json['chapters']    = chapters()
    json['floorplans']  = floorplans()
    json['images']      = images()
    json['downloads']   = downloads()
    json['documents']   = documents()
    json
  end

  def <=>(other)
    return group_sort_key <=> other.group_sort_key if group_sort_key != other.group_sort_key
    return building_sort_key <=> other.building_sort_key if building_sort_key != other.building_sort_key
    return figure.floor <=> other.figure.floor if figure.floor != other.figure.floor
    return surface_value <=> other.surface_value if surface_value != other.surface_value
    0
  end

  def building_sort_key
    sort_key = building_key.split('/').first() if building_key.present?
    return building_key if sort_key.to_i == 0
    sort_key.to_i
  end

end
