class PriceUnit

  class << self

    def all_by_offer_and_utilization(offer, utilization)
      if offer == Offer::RENT
        if utilization == Utilization::PARKING
          for_rent_parking
        else
          for_rent
        end
      elsif offer == Offer::SALE
        if utilization == Utilization::PARKING
          for_sale_parking
        else
          for_sale
        end
      end
    end

    def for_rent
      %w(monthly year_m2 yearly weekly daily)
    end

    def for_sale
      %w(sell sell_m2)
    end

    def for_rent_parking
      %w(monthly)
    end

    def for_sale_parking
      %w(sell)
    end

    def per_square_meter_per_year
      'year_m2'
    end
  end
end
