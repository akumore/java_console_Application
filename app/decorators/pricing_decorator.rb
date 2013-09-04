class PricingDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :pricing

  def list_price
    if model.for_rent?
      if model.estimate.present?
        model.estimate
      else
        price_value = model.private_utilization? ? model.for_rent_brutto : model.for_rent_netto
        formatted_price(price_value)
      end
    elsif model.for_sale?
      if model.estimate.present?
        model.estimate
      else
        formatted_price(model.for_sale)
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

  def for_rent_extra
    if model.for_rent_extra.present? && model.for_rent?
      formatted(model.for_rent_extra)
    end
  end

  def storage
    formatted(model.storage) if model.storage.present?
  end

  def extra_storage
    formatted(model.extra_storage) if model.extra_storage.present?
  end

  def inside_parking
    formatted(model.inside_parking, parking_price_unit) if model.inside_parking.present?
  end

  def outside_parking
    formatted(model.outside_parking, parking_price_unit) if model.outside_parking.present?
  end

  def covered_slot
    formatted(model.covered_slot, parking_price_unit) if model.covered_slot.present?
  end

  def covered_bike
    formatted(model.covered_bike, parking_price_unit) if model.covered_bike.present?
  end

  def outdoor_bike
    formatted(model.outdoor_bike, parking_price_unit) if model.outdoor_bike.present?
  end

  def single_garage
    formatted(model.single_garage, parking_price_unit) if model.single_garage.present?
  end

  def double_garage
    formatted(model.double_garage, parking_price_unit) if model.double_garage.present?
  end

  def for_rent_depot
    if model.for_rent? && model.for_rent_depot.present?
      formatted_price(model.for_rent_depot)
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

    if for_rent_extra.present?
      content << { :key => t('pricings.for_rent_extra'), :value => for_rent_extra }
    end

    if for_rent_depot.present?
      content << { :key => t('pricings.for_rent_depot'), :value => for_rent_depot }
    end

    if inside_parking.present?
      content << { :key => t('pricings.inside_parking'), :value => inside_parking }
    end

    if outside_parking.present?
      content << { :key => t('pricings.outside_parking'), :value => outside_parking }
    end

    if real_estate.information.present? && real_estate.information.available_from.present?
      content << { :key => t('information.available_from'), :value => I18n.l(real_estate.information.available_from) }
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

  private

  def formatted(price, price_unit = nil)
    price_unit ||= model.price_unit
    t("pricings.decorator.price_units.#{price_unit}", :price => formatted_price(price))
  end

  def formatted_price price
    number_to_currency(price, :locale => 'de-CH')
  end

  def parking_price_unit
    if model.for_sale?
      'sell'
    else
      'monthly'
    end
  end
end
