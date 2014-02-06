require 'constants'

module Offer
  include Constants::Offer

  module Accessors
    def for_rent?
      offer == Offer::RENT
    end

    def for_sale?
      offer == Offer::SALE
    end
  end
end
