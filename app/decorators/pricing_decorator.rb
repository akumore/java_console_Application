class PricingDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :pricing

  def list_price
    if model.for_rent?
      if model.estimate.present?
        model.estimate
      else
        price_value = model.private_utilization? ? model.for_rent_brutto : model.for_rent_netto
        formatted_number_with_currency(price_value)
      end
    elsif model.for_sale?
      if model.estimate.present?
        model.estimate
      else
        formatted_number_with_currency(model.for_sale)
      end
    end
  end

  def for_rent_netto
    if model.for_rent?
      if model.estimate.present?
        model.estimate
      elsif model.for_rent_netto.present?
        formatted_number(model.for_rent_netto)
      end
    end
  end

  def for_rent_brutto
    if model.for_rent?
      if model.estimate.present?
        model.estimate
      elsif model.for_rent_brutto.present?
        formatted_number(model.for_rent_brutto)
      end
    end
  end

  def for_sale
    if model.for_sale?
      if model.estimate.present?
        model.estimate
      elsif model.for_sale.present?
        formatted_number(model.for_sale)
      end
    end
  end

  def additional_costs
    if model.additional_costs.present? && !model.parking?
      formatted_number(model.additional_costs)
    end
  end

  def storage
    formatted_number(model.storage) if model.storage.present?
  end

  def extra_storage
    formatted_number(model.extra_storage) if model.extra_storage.present?
  end

  def inside_parking
    formatted_number(model.inside_parking) if model.inside_parking.present?
  end

  def outside_parking
    formatted_number(model.outside_parking) if model.outside_parking.present?
  end

  def covered_slot
    formatted_number(model.covered_slot) if model.covered_slot.present?
  end

  def covered_bike
    formatted_number(model.covered_bike) if model.covered_bike.present?
  end

  def outdoor_bike
    formatted_number(model.outdoor_bike) if model.outdoor_bike.present?
  end

  def single_garage
    formatted_number(model.single_garage) if model.single_garage.present?
  end

  def double_garage
    formatted_number(model.double_garage) if model.double_garage.present?
  end

  def chapter
    content = []
    content_html = ''

    if for_sale.present?
      content << { :key => t('pricings.for_sale'), :value => for_sale }
    end

    if for_rent_netto.present?
      content << { :key => t('pricings.for_rent_netto'), :value => for_rent_netto }
    end

    if additional_costs.present?
      content << { :key => t('pricings.additional_costs'), :value => additional_costs }
    end

    if inside_parking.present?
      content << { :key => t('pricings.inside_parking'), :value => inside_parking }
    end

    if outside_parking.present?
      content << { :key => t('pricings.outside_parking'), :value => outside_parking }
    end

    if opted?
      content_html << content_tag(:p, t('pricings.without_vat'))
    end

    {
      :title        => t('pricings.title'),
      :collapsible  => true,
      :content_html => content_html,
      :content      => content
    }
  end

  def render_pricing_field(pricing_field)
    if pricing && self.send(pricing_field).present?
      content_tag(:dl, render_definition_list(pricing_field))
    end
  end

  def render_definition_list(pricing_field)
    render_definition_title(pricing_field) + render_definition_description(pricing_field)
  end

  def render_definition_title(pricing_field)
    content_tag(:dt) do
      if pricing_field == :for_rent_netto
        self._parent.category.label + " " +
        t("pricings.#{pricing_field}")
      elsif pricing_field == :for_sale
        self._parent.category.label
      else
        t("pricings.#{pricing_field}")
      end
    end
  end

  def render_definition_description(pricing_field)
    content_tag(:dd) do
      render_price_tags(self.send(pricing_field), price_unit(pricing_field))
    end
  end

  def render_price_tags(price, price_unit)
    [
      content_tag(:span, price, :class => 'value'),
      content_tag(:span, price_unit, :class => 'currency')
    ].join().html_safe
  end

  def price_unit(pricing_field=nil)
    if Pricing::PARKING_PRICING_FIELDS.include?(pricing_field)
      parking_price_unit
    else
      t("pricings.decorator.price_units.#{model.price_unit}")
    end
  end

  def parking_price_unit
    if model.for_sale?
      t("pricings.decorator.price_units.sell")
    else
      t("pricings.decorator.price_units.monthly")
    end
  end

  private

  def formatted_number(price)
    number_to_currency(price, :locale => 'de-CH', :format => "%n")
  end

  def formatted_number_with_currency(price)
    number_to_currency(price, :locale => 'de-CH', :format => "%n %u")
  end
end
