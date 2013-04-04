class RealEstateDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :real_estate
  decorates_association :contact
  decorates_association :address
  decorates_association :information
  decorates_association :pricing
  decorates_association :figure
  decorates_association :infrastructure
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
    [address.try(:street).presence, address.try(:extended_city).presence].join(tag('br')).html_safe
  end

  def short_info_second
    buffer = []

    buffer << utilization_description if utilization_description.present? && living? || working? || storing?
    if figure.present?
      buffer << figure.rooms if figure.rooms.present? && living?
    end

    buffer.join(tag('br')).html_safe
  end

  def short_info_third
    buffer = []

    if figure.present? && !parking?
      buffer << figure.surface if figure.surface.present?
      buffer << figure.floor if figure.floor.present?
    end

    buffer.join(tag('br')).html_safe
  end

  def short_info_fourth
    buffer = []

    if model.pricing.present?
      buffer << pricing.price if pricing.price.present?
    end

    if information.try(:available_from_compact).present?
      buffer << information.available_from_compact
    end

    buffer.join(tag('br')).html_safe
  end

  def description
    if model.description.present?
      markdown model.description
    end
  end

  def utilization_description
    if model.utilization_description.present?
      model.utilization_description
    else
      category.try(:label)
    end
  end

  def seo_description
    sanitized_description = strip_tags(markdown(description)).chomp.chomp if description.present?
    [title, address.try(:simple), sanitized_description].compact.join ' - '
  end

  def mini_doku_link
    link_to(
        t('real_estates.show.description_download'),
        real_estate_handout_path(
          :real_estate_id => model.id,
          :format => :pdf),
        :class => 'icon-description', :target => '_blank'
    ) if model.has_handout?
  end

  def object_documentation_title
    model.handout.filename
  end

  def application_form_link
    if model.for_rent? && !model.parking?
      link = if model.private_utilization?
        if I18n.locale == :it
          '/documents/it/Formulario-di-contatto-Affittare-Abitare.pdf'
        elsif I18n.locale == :fr
          '/documents/fr/Formulaire-d-Inscription-Louer-Habiter.pdf'
        else
          '/documents/de/Anmeldeformular-Mieten-Wohnen.pdf'
        end
      elsif model.commercial_utilization?
        if I18n.locale == :it
          '/documents/it/Formulario-di-contatto-Affittare-Lavorare.pdf'
        elsif I18n.locale == :fr
          '/documents/fr/Formulaire-d-Inscription-Louer-Travailler.pdf'
        else
          '/documents/de/Anmeldeformular-Mieten-Gewerbe.pdf'
        end
      end
      link_to(t('real_estates.show.application_form'), link, :class => 'icon-description', :target => '_blank')
    end
  end

  def floorplan_link
    if model.floor_plans.exists?
      link_to t('real_estates.show.floorplan'), '#', :class => 'icon-groundplan'
    end
  end

  def floorplan_print_link
    if model.floor_plans.exists?
      link_to t('real_estates.show.print_floorplan'), real_estate_floorplans_path(model, :print => true), :class => 'icon-printer', :target => '_blank'
    end
  end

  def project_website_link
    if address.present? && address.link_url.present?
      link_to t('real_estates.show.project_website_link'), address.link_url, :target => '_new', :class => 'icon-globe'
    end
  end

  def north_arrow_overlay
    additional_description = real_estate.additional_description
    if additional_description.present? && additional_description.orientation_degrees.present?
      h.content_tag(:div, :class => "north-arrow-container") do
        north_arrow_img_tag
      end
    end
  end

  def north_arrow_img_tag
    img = north_arrow_img
    if north_arrow_img.present?
      h.image_tag(img, :class => 'north-arrow')
    end
  end

  def north_arrow_img
    if real_estate.additional_description.present? and real_estate.additional_description.orientation_degrees.present?
      angle = real_estate.additional_description.orientation_degrees.to_i
      angle = angle - angle % 5
      "north-arrow/#{angle}.png"
    end
  end

  def thumbnail
    if parking?
      image_path({
              'open_slot'                   => 'parking_thumbnails/open_slot.jpg',
              'covered_slot'                => 'parking_thumbnails/covered_slot.jpg',
              'single_garage'               => 'parking_thumbnails/covered_slot.jpg',
              'double_garage'               => 'parking_thumbnails/covered_slot.jpg',
              'underground_slot'            => 'parking_thumbnails/covered_slot.jpg',
              'covered_parking_place_bike'  => 'parking_thumbnails/covered_slot_bike.jpg',
              'outdoor_parking_place_bike'  => 'parking_thumbnails/covered_slot_bike.jpg'
            }.fetch(category.name, 'parking_thumbnails/open_slot.jpg'))
    else
      images.primary.file.thumb.url
    end
  end

  def any_information?
    if parking?
      general_information? || parking_information?
    elsif living?
      general_information? || living_information?
    elsif working?
      general_information? || working_information?
    elsif storing?
      general_information? || storing_information?
    end
  end

  def general_information?
    if figure.present?
      figure.floors.present? ||
      figure.renovated_on.present? ||
      figure.built_on.present? ||
      figure.built_on.present?
    elsif information.present?
      information.characteristics.any?
    end
  end

  def parking_information?
    false
  end

  def living_information?
    if figure.present?
      figure.floor.present? ||
      figure.rooms.present? ||
      figure.surface.present?
    end
  end

  def working_information?
    if figure.present?
      figure.property_surface.present? ||
      figure.storage_surface.present? ||
      figure.ceiling_height.present?
    elsif information.present?
      information.maximal_floor_loading.present? ||
      information.freight_elevator_carrying_capacity.present?
    end
  end

  def storing_information?
    figure.ceiling_height.present?
  end
end
