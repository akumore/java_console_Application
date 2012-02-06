class RealEstateDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  decorates :real_estate

  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #
  #   Or, optionally enable "lazy helpers" by including this module:
  #     include Draper::LazyHelpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #
  #   def created_at
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"),
  #                   :class => 'timestamp'
  #   end

  def full_address
    [
      category.try(:label).presence,
      [
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
      buffer << t('real_estates.show.floor', :floor => figure.floor)
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

end