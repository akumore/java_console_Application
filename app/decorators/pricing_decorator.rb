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

  def price
    if model.for_rent?
      for_rent_netto
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

  def inside_parking
    formatted(model.inside_parking, parking_price_unit) if model.inside_parking.present?
  end

  def outside_parking
    formatted(model.outside_parking, parking_price_unit) if model.outside_parking.present?
  end

  def inside_parking_temporary
    formatted(model.inside_parking_temporary, parking_price_unit) if model.inside_parking_temporary.present?
  end

  def outside_parking_temporary
    formatted(model.outside_parking_temporary, parking_price_unit) if model.outside_parking_temporary.present?
  end

  def for_rent_depot
    if model.for_rent? && model.for_rent_depot.present?
      formatted_price(model.for_rent_depot)
    end
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
