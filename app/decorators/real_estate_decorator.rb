# encoding: utf-8
require 'google_analytics_category_translator'

class RealEstateDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include GoogleAnalyticsCategoryTranslator

  decorates :real_estate
  decorates_association :contact
  decorates_association :address
  decorates_association :information
  decorates_association :pricing
  decorates_association :figure
  decorates_association :floor_plans

  def initialize(*args)
    super(*args)
    if for_rent?
      if living?
        self.extend Rent::LivingDecorator
      elsif working?
        self.extend Rent::WorkingDecorator
      elsif storing?
        self.extend Rent::StoringDecorator
      elsif parking?
        self.extend Rent::ParkingDecorator
      end
    elsif for_sale?
      if living?
        self.extend Rent::LivingDecorator
      elsif working?
        self.extend Rent::WorkingDecorator
      elsif storing?
        self.extend Rent::StoringDecorator
      elsif parking?
        self.extend Rent::ParkingDecorator
      end
    end
  end

  def google_maps_address
    [
      address.try(:street).presence, address.try(:street_number).presence,
      address.try(:zip).presence,
      address.try(:city).presence,
      address.try(:canton).try(:upcase).presence
    ].join(' ')
  end

  def short_info_first
    buffer = []

    buffer << address.street
    buffer << address.compressed_city

    buffer.join(tag('br')).html_safe
  end

  def short_info_second
    buffer = []

    buffer << tag('br') if parking?

    buffer << figure.rooms if figure.try(:rooms).present? && living?

    if figure.present?
      buffer << figure.surface if figure.surface.present? && working? || storing?
      buffer << figure.floor if figure.floor.present? && !parking?
    end

    buffer.join(tag('br')).html_safe
  end

  def short_info_third
    buffer = []

    buffer << pricing.list_price if living? || parking?

    buffer << utilization_description if utilization_description.present? && working? || storing?

    if pricing.present?
      buffer << pricing.available_from_compact
    end

    buffer.join(tag('br')).html_safe
  end

  def short_info_detail_first
    [address.try(:street).presence, address.try(:extended_city).presence].join(tag('br')).html_safe
  end

  def short_info_detail_second
    buffer = []

    buffer << utilization_description if utilization_description.present? && living? || working? || storing?

    if figure.present?
      buffer << figure.rooms if figure.rooms.present? && living?
    end

    buffer.join(tag('br')).html_safe
  end

  def short_info_detail_third
    buffer = []

    if figure.present? && !parking?
      buffer << figure.surface if figure.surface.present?
      buffer << figure.floor if figure.floor.present?
    end

    buffer.join(tag('br')).html_safe
  end

  def short_info_detail_fourth
    buffer = []

    if model.pricing.present?
      buffer << pricing.list_price if pricing.list_price.present?
    end

    if pricing.try(:available_from_compact).present?
      buffer << pricing.available_from_compact
    end

    buffer.join(tag('br')).html_safe
  end

  def description
    if model.description.present?
      model.description.html_safe
    end
  end

  def utilization_description
    if model.utilization_description.present?
      consistent_util_desc = model.utilization_description.gsub(/\s+/, '')
      consistent_util_desc.gsub!(/,|\//, '/')
      consistent_util_desc.gsub!(/#{category.try(:label)}\/|\/#{category.try(:label)}|#{category.try(:label)}/, '')
      "#{category.try(:label)}/#{consistent_util_desc}"
    else
      category.try(:label)
    end
  end

  def seo_description
    sanitized_description = Sanitize.clean(strip_tags(description).chomp.chomp) if description.present?
    [title, address.try(:simple), sanitized_description].compact.join ' - '
  end

  def seo_title
    if living?
      detail = figure.rooms if figure.try(:rooms).present?
    elsif working? || storing?
      detail = figure.surface if figure.surface.present?
    elsif parking?
      detail = "Parkieren"
    end

    city = model.address.city

    utilization = I18n.t(".real_estates.search_filter." + model.offer + "")

    "#{detail} - #{model.address.city} - #{utilization} - Alfred Müller AG"
  end

  def handout_order_link
    if model.order_handout? && (model.working? || model.living?)
      link_to t('real_estates.show.handout_order'), '#', :class => 'icon-handout-order icon-description'
    end
  end

  def mini_doku_link
    return unless model.has_handout?

    data = {
      'ga-category' => translate_category(model),
      'ga-action' => "Objektdokumentation",
      'ga-label' => address.try(:simple)
    }

    link = real_estate_handout_path(real_estate_id: model.id, format: :pdf)
    link.gsub!('handout.pdf', "#{model.handout.printout_filename}.pdf")

    link_to(t('real_estates.show.description_download'), link, {
      data: data,
      class: 'icon-description ga-tracking-link',
      target: '_blank'})
  end

  def render_document_links
    buffer = []

    model.documents.each do |doc|
      buffer << content_tag(:li) do
        link_to(
            doc.title,
            doc.file.url,
            :class => 'icon icon-pdf ga-tracking-link', :target => '_blank',
            data: {
                    'ga-category' => translate_category(model),
                    'ga-action' => doc.title,
                    'ga-label' => address.try(:simple)
                  }
        )
      end
    end

    buffer.join.html_safe
  end

  def application_form_link
    if model.show_application_form? && model.for_rent? && !model.parking?
      link = if model.living?
        if I18n.locale == :it
          '/documents/it/Formulario-di-contatto-Affittare-Abitare.pdf'
        elsif I18n.locale == :fr
          '/documents/fr/Formulaire-d-Inscription-Louer-Habiter.pdf'
        else
          '/documents/de/Anmeldeformular-Mieten-Wohnen.pdf'
        end
      elsif model.working? || model.storing?
        if I18n.locale == :it
          '/documents/it/Formulario-di-contatto-Affittare-Lavorare.pdf'
        elsif I18n.locale == :fr
          '/documents/fr/Formulaire-d-Inscription-Louer-Travailler.pdf'
        else
          '/documents/de/Anmeldeformular-Mieten-Gewerbe.pdf'
        end
      end
      link_to(
        t('real_estates.show.application_form'),
        link,
        :class => 'application-form-link icon-description ga-tracking-link',
        :target => '_blank',
        data: {
                'ga-category' => translate_category(model),
                'ga-action' => "Anmeldeformular",
                'ga-label' => address.try(:simple)
              }
      )
    end
  end

  def floorplan_link
    if model.floor_plans.exists?
      link_to(
        t('real_estates.show.floorplan'),
        '#',
        :class => 'icon-groundplan ga-tracking-link',
        data: {
                'ga-category' => translate_category(model),
                'ga-action' => "Grundriss anzeigen",
                'ga-label' => address.try(:simple)
              }
      )
    end
  end

  def floorplan_print_link(floor_plan = nil)
    if model.floor_plans.exists?
      link_to(
        t('real_estates.show.print_floorplan'),
        floorplan_print_path(floor_plan),
        :class => 'icon-printer ga-tracking-link',
        :target => '_blank',
        data: {
                'ga-category' => translate_category(model),
                'ga-action' => "Grundriss drucken",
                'ga-label' => address.try(:simple)
              }
      )
    end
  end

  def floorplan_print_path(floor_plan = nil)
    if floor_plan
      real_estate_floorplan_path(model, floor_plan, :print => true)
    else
      real_estate_floorplans_path(model, :print => true)
    end
  end

  def project_website_link
    if link_url.present?
      link = if link_url =~ /https?:\/\//
               link_url
             else
               'http://' + link_url
             end

      link_to t('real_estates.show.project_website_link'), link, :target => '_new', :class => 'icon-globe'
    end
  end

  def thumbnail
    if parking?
      image_path({
              'outside_parking'       => 'parking_thumbnails/open_slot.jpg',
              'covered_slot'          => 'parking_thumbnails/covered_slot.jpg',
              'single_garage'         => 'parking_thumbnails/covered_slot.jpg',
              'double_garage'         => 'parking_thumbnails/covered_slot.jpg',
              'inside_parking'        => 'parking_thumbnails/covered_slot.jpg',
              'covered_bike'          => 'parking_thumbnails/covered_slot_bike.jpg',
              'outdoor_bike'          => 'parking_thumbnails/covered_slot_bike.jpg'
            }.fetch(category.name, 'parking_thumbnails/open_slot.jpg'))
    else
      images.primary.file.thumb.url
    end
  end

  def channels_string
    channels.map { |channel|
      channel_str = I18n.t("cms.real_estates.form_channels.channels.#{channel}")
      if channel == RealEstate::PRINT_CHANNEL && print_channel_method.present?
        channel_str << " (#{I18n.t("cms.real_estates.form_channels.#{print_channel_method}")})"
      end
      channel_str
    }.join(", ")
  end
end
