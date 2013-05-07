class PricingDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :pricing

  #
  # Fields are used for _pricing partial of a real estate
  #
  def pricing_fields
    [
      :for_sale,
      :for_rent_netto,
      :additional_costs,
      :storage,
      :extra_storage,
      :inside_parking,
      :outside_parking,
      :covered_slot,
      :covered_bike,
      :outdoor_bike,
      :single_garage,
      :double_garage
    ]
  end

  def parking_pricing_fields
    [
      :inside_parking,
      :outside_parking,
      :covered_slot,
      :covered_bike,
      :outdoor_bike,
      :single_garage,
      :double_garage
    ]
  end

  def list_price
    if model.for_rent?
      if model.estimate.present?
        model.estimate
      else
        price_value = model.private_utilization? ? model.for_rent_brutto : model.for_rent_netto
        formatted(price_value)
      end
    elsif model.for_sale?
      if model.estimate.present?
        model.estimate
      else
        formatted(model.for_sale)
      end
    end
  end

  def price
    if model.for_rent?
      if model.private_utilization?
        for_rent_brutto
      else
        for_rent_netto
      end
    elsif model.for_sale?
      for_sale
    end
  end

  def for_rent_netto
    if model.for_rent?
      if model.estimate.present?
        model.estimate
      elsif model.for_rent_netto.present?
        formatted(model.for_rent_netto)
      end
    end
  end

  def for_rent_brutto
    if model.for_rent?
      if model.estimate.present?
        model.estimate
      elsif model.for_rent_brutto.present?
        formatted(model.for_rent_brutto)
      end
    end
  end

  def for_sale
    if model.for_sale?
      if model.estimate.present?
        model.estimate
      elsif model.for_sale.present?
        formatted(model.for_sale)
      end
    end
  end

  def additional_costs
    if model.additional_costs.present? && !model.parking?
      formatted(model.additional_costs)
    end
  end

  def storage
    formatted(model.storage) if model.storage.present?
  end

  def extra_storage
    formatted(model.extra_storage) if model.extra_storage.present?
  end

  def inside_parking
    formatted(model.inside_parking) if model.inside_parking.present?
  end

  def outside_parking
    formatted(model.outside_parking) if model.outside_parking.present?
  end

  def covered_slot
    formatted(model.covered_slot) if model.covered_slot.present?
  end

  def covered_bike
    formatted(model.covered_bike) if model.covered_bike.present?
  end

  def outdoor_bike
    formatted(model.outdoor_bike) if model.outdoor_bike.present?
  end

  def single_garage
    formatted(model.single_garage) if model.single_garage.present?
  end

  def double_garage
    formatted(model.double_garage) if model.double_garage.present?
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
      concat(content_tag(:span, :class => 'value') do
        self.send(pricing_field)
      end)
      concat(content_tag(:span, :class => 'currency') do
        if parking_pricing_fields.include?(pricing_field)
          parking_price_unit
        elsif pricing_field != :for_sale
          currency_price_unit
        end
      end)
    end
  end

  def currency_price_unit
    price_unit ||= model.price_unit
    t("pricings.decorator.price_units.#{price_unit}")
  end

  private

  def formatted(price)
    number_to_currency(price, :locale => 'de-CH', :format => "%n&nbsp;".html_safe)
  end

  def parking_price_unit
    if model.for_sale?
      t("pricings.decorator.price_units.sell")
    else
      t("pricings.decorator.price_units.monthly")
    end
  end
end
