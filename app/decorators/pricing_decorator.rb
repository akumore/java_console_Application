class PricingDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :pricing

  INVARIANT_PRICING_FIELDS = Pricing::PRICING_FIELDS - [:for_rent_netto, :for_sale, :for_rent_netto_monthly]

  def list_price
    if model.for_rent?
      if model.estimate.present?
        model.estimate
      else
        price_value = model.private_utilization? ? model.for_rent_brutto : model.for_rent_netto
        formatted_price_with_currency(price_value)
      end
    elsif model.for_sale?
      if model.estimate.present?
        model.estimate
      else
        formatted_price_with_currency(model.for_sale)
      end
    end
  end

  def for_rent_netto
    formatted_price(model.for_rent_netto)
  end

  def for_sale
    formatted_price(model.for_sale)
  end

  def for_rent_brutto
    if model.for_rent?
      if model.estimate.present?
        model.estimate
      elsif model.for_rent_brutto.present?
        formatted_price(model.for_rent_brutto)
      end
    end
  end

  def additional_costs
    if model.additional_costs.present? && !model.parking?
      formatted_price(model.additional_costs)
    end
  end

  def storage
    formatted_price(model.storage) if model.storage.present?
  end

  def extra_storage
    formatted_price(model.extra_storage) if model.extra_storage.present?
  end

  def inside_parking
    formatted_price(model.inside_parking) if model.inside_parking.present?
  end

  def outside_parking
    formatted_price(model.outside_parking) if model.outside_parking.present?
  end

  def covered_slot
    formatted_price(model.covered_slot) if model.covered_slot.present?
  end

  def covered_bike
    formatted_price(model.covered_bike) if model.covered_bike.present?
  end

  def outdoor_bike
    formatted_price(model.outdoor_bike) if model.outdoor_bike.present?
  end

  def single_garage
    formatted_price(model.single_garage) if model.single_garage.present?
  end

  def double_garage
    formatted_price(model.double_garage) if model.double_garage.present?
  end

  #
  # Monthly pricing fields need to be formatted too
  #
  def for_rent_netto_monthly
    formatted_price(model.for_rent_netto_monthly)
  end

  def additional_costs_monthly
    formatted_price(model.additional_costs_monthly) if model.additional_costs_monthly.present?
  end

  def storage_monthly
    formatted_price(model.storage_monthly) if model.storage_monthly.present?
  end

  def extra_storage_monthly
    formatted_price(model.extra_storage_monthly) if model.extra_storage_monthly.present?
  end

  def estimate_monthly
    formatted_price(model.estimate_monthly) if model.estimate_monthly.present?
  end

  def price_to_be_displayed
    if model.for_rent?
      if estimate.present?
        estimate
      else
        for_rent_netto
      end
    else
      if estimate.present?
        estimate
      else
        for_sale
      end
    end
  end

  def price_to_be_displayed_monthly
    if model.for_rent?
      if estimate_monthly.present?
        estimate_monthly
      else
        for_rent_netto_monthly
      end
    end
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
      if pricing_field == :price_to_be_displayed
        if model.for_rent?
          self._parent.category.label + " " +
          t("pricings.for_rent_netto")
        else
          self._parent.category.label
        end
      else
        t("pricings.#{pricing_field}")
      end
    end
  end

  def render_definition_description(pricing_field)
    content_tag(:dd) do
      concat render_price_tags(self.send(pricing_field), price_unit(pricing_field), pricing_field)
      monthly_field = "#{pricing_field}_monthly".to_sym
      if respond_to?(monthly_field) and
        send(monthly_field).present? and
        model.supports_monthly_prices?
        concat render_price_tags(send(monthly_field), price_unit(monthly_field), monthly_field)
      end
    end
  end

  def render_price_tags(price, price_unit, pricing_field = nil)
    if pricing_field == :price_to_be_displayed && model.estimate.present? || pricing_field == :price_to_be_displayed_monthly && model.estimate_monthly.present?
      content_tag(:span, price, :class => "value value-string #{pricing_field.to_s}")
    elsif model.supports_monthly_prices? && (Pricing::PARKING_PRICING_FIELDS.include?(pricing_field) || Pricing::MONTHLY_PRICING_FIELDS.include?(pricing_field))
      [
        content_tag(:span, price_unit, :class => 'currency currency-monthly'),
        content_tag(:span, price, :class => 'value value-monthly')
      ].join().html_safe
    else
      [
        content_tag(:span, price, :class => 'value'),
        content_tag(:span, price_unit, :class => 'currency')
      ].join().html_safe
    end
  end

  def price_unit(pricing_field = nil)
    if Pricing::PARKING_PRICING_FIELDS.include?(pricing_field)
      parking_price_unit
    elsif Pricing::MONTHLY_PRICING_FIELDS.include?(pricing_field)
      t("pricings.decorator.price_units.monthly")
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

  def more_than_seven_digits?(price)
    price.is_a? Numeric and price >= 1000000
  end

  def formatted_price(price)
    number_to_currency(
      humanize_million_price(price),
      :locale => 'de-CH',
      :format => "%n",
      :delimiter => ' '
    )
  end

  def formatted_price_with_currency(price)
    number_to_currency(
      humanize_million_price(price),
      :locale => 'de-CH',
      :format => "%n %u",
      :delimiter => ' '
    )
  end

  def humanize_million_price(price)
    if more_than_seven_digits?(price)
      number_to_human(
        price,
        :significant => false,
        :significant_digits => 2,
        :precision => 2,
        :locale => 'de-CH'
      )
    else
      price
    end
  end
end
