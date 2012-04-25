class PricingDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :pricing

  def list_price
    if model.for_rent?
      if model.estimate.present?
        model.estimate
      else
        formatted_price(model.for_rent_netto)
      end
    elsif model.for_sale?
      if model.estimate.present?
        model.estimate
      else
        formatted_price(model.for_sale)
      end
    end
  end

  def for_rent_netto
    if model.estimate.present?
      estimate
    elsif model.for_rent_netto.present?
      formatted(model.for_rent_netto)
    end
  end

  def for_sale
    if model.estimate.present?
      estimate
    elsif model.for_sale.present?
      formatted(model.for_sale)
    end
  end

  def for_rent_extra
    formatted(model.for_rent_extra) if model.for_rent_extra.present?
  end

  def inside_parking
    formatted(model.inside_parking) if model.inside_parking.present?
  end

  def outside_parking
    formatted(model.outside_parking) if model.outside_parking.present?
  end

  def inside_parking_temporary
    formatted(model.inside_parking_temporary) if model.inside_parking_temporary.present?
  end

  def outside_parking_temporary
    formatted(model.outside_parking_temporary) if model.outside_parking_temporary.present?
  end

  def estimate
    t("pricings.decorator.price_units.#{model.price_unit}", :price => model.estimate) if model.estimate.present?
  end

  private

  def formatted price
    t("pricings.decorator.price_units.#{model.price_unit}", :price => formatted_price(price))
  end

  def formatted_price price
    number_to_currency(price, :locale => 'de-CH')
  end
end
