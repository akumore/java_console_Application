class RealEstateDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :real_estate
  decorates_association :contact
  decorates_association :address
  decorates_association :information
  decorates_association :pricing
  decorates_association :figure
  decorates_association :infrastructure

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
    buffer << utilization_description

    if model.pricing.present?
      buffer << pricing.price if pricing.price.present?
    end

    buffer.join(tag('br')).html_safe
  end

  def short_info_figure
    buffer = []

    if figure.present?
      buffer << figure.rooms if figure.rooms.present?
      buffer << figure.floor if figure.floor.present?
    end

    buffer.join(tag('br')).html_safe
  end

  def short_info_size
    buffer = []

    if figure.present?
      buffer << figure.surface if figure.surface.present?
    end

    if information.try(:available_from_compact).present?
      buffer << information.available_from_compact
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
        real_estate_object_documentation_path(
          :real_estate_id => model.id,
          :format => :pdf,
          :name => "Objektdokumentation-#{model.title.parameterize}"),
        :class => 'icon-description', :target => '_blank'
    ) if model.has_handout?
  end

  def floorplan_link
    if model.floor_plans.exists?
      link_to t('real_estates.show.floorplan'), '#', :class => 'icon-groundplan'
    end
  end

  def project_website_link
    if address.present? && address.link_url.present?
      link_to t('real_estates.show.project_website_link'), address.link_url, :target => '_new', :class => 'icon-globe'
    end
  end
end
