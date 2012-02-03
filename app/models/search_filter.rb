class SearchFilter < OpenStruct
  include ActiveModel::Conversion
  extend ActiveModel::Translation

  #attr_accessor :offer, :utilization, :canton, :city

  SALE = 'for_sale'
  RENT = 'for_rent'

  NON_COMMERCIAL = 'private'
  COMMERCIAL = 'commercial'

  def initialize(params={})
    super params.reverse_merge(:offer=>RENT, :utilization=>NON_COMMERCIAL)
  end

  def persisted?
    false
  end

  def for_rent?
    offer == RENT
  end

  def for_sale?
    offer == SALE
  end

  def commercial?
    utilization == COMMERCIAL
  end

  def to_h
    { :offer=>offer, :utilization=>utilization }
  end

end