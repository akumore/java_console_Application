module Offer

  RENT = 'for_rent'
  SALE = 'for_sale'

  module Accessors
    def for_rent?
      offer == RENT
    end

    def for_sale?
      offer == SALE
    end
  end
end
