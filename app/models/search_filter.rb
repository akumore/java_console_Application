class SearchFilter < OpenStruct
  include ActiveModel::Conversion
  extend ActiveModel::Translation

  #attr_accessor :offer, :utilization, :canton, :city

  SALE = RealEstate::OFFER_FOR_SALE
  RENT = RealEstate::OFFER_FOR_RENT

  NON_COMMERCIAL =  RealEstate::UTILIZATION_PRIVATE
  COMMERCIAL = RealEstate::UTILIZATION_COMMERICAL

  def initialize(params={})
    params[:offer] ||= RENT
    params[:utilization] ||= NON_COMMERCIAL
    super
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