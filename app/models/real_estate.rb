class RealEstate
  include Mongoid::Document
  include Mongoid::Timestamps

  UTILIZATION_PRIVATE = 'private'
  UTILIZATION_COMMERICAL = 'commercial'

  BUILDING_CORNER_HOUSE = 'corner_house'
  BUILDING_MIDDLE_HOUSE = 'middle_house'

  OFFER_FOR_RENT = 'for_rent'
  OFFER_FOR_SALE = 'for_sale'

  STATE_EDITING = 'editing'

  CHANNELS = %w(website homegate print)

  belongs_to :category
  belongs_to :contact

  embeds_one :reference
  embeds_one :address
  embeds_one :pricing
  embeds_one :figure
  embeds_one :infrastructure

  field :state, :type => String, :default => RealEstate::STATE_EDITING
  field :utilization, :type => String, :default => RealEstate::UTILIZATION_PRIVATE
  field :offer, :type => String, :default => RealEstate::OFFER_FOR_RENT
  field :channels, :type => Array, :default => [RealEstate::CHANNELS.first]
  field :title, :type => String
  field :property_name, :type => String
  field :description, :type => String
  field :short_description, :type => String
  field :keywords, :type => String
  field :is_first_marketing, :type => Boolean
  field :building_type, :type => String
  field :utilization_description, :type => String

  after_initialize :init_channels
  
  def row_house?
    category.present? && category.name == 'row_house'
  end
  
  def for_sale?
    self.offer == RealEstate::OFFER_FOR_SALE
  end

  def for_rent?
    self.offer == RealEstate::OFFER_FOR_RENT
  end

  def commercial_utilization?
    self.utilization == RealEstate::UTILIZATION_COMMERICAL
  end
  
  private
  def init_channels
    self.channels ||= []
  end

end
