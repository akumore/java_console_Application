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

  REFERENCE_PROJECT_CHANNEL = "reference_projects"
  WEBSITE_CHANNEL = "website"
  CHANNELS = %W(#{WEBSITE_CHANNEL} homegate print #{REFERENCE_PROJECT_CHANNEL})

  belongs_to :category
  belongs_to :contact, :class_name => 'Employee'
  has_many :appointments

  embeds_one :reference
  embeds_one :address
  embeds_one :pricing
  embeds_one :figure
  embeds_one :information
  embeds_one :infrastructure
  embeds_one :descriptions, :class_name => 'Description'
  embeds_many :media_assets  do
    def primary_image
      images.primary.first || MediaAsset.new(:media_type => MediaAsset::IMAGE)
    end
  end

  field :state, :type => String, :default => RealEstate::STATE_EDITING
  field :utilization, :type => String, :default => RealEstate::UTILIZATION_PRIVATE
  field :offer, :type => String, :default => RealEstate::OFFER_FOR_RENT
  field :channels, :type => Array, :default => [RealEstate::WEBSITE_CHANNEL]
  field :title, :type => String
  field :property_name, :type => String
  field :description, :type => String
  field :short_description, :type => String
  field :keywords, :type => String
  field :is_first_marketing, :type => Boolean
  field :building_type, :type => String
  field :utilization_description, :type => String

  validates :category_id, :presence => true
  validates :state, :presence => true
  validates :utilization, :presence => true
  validates :offer, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true

  after_initialize :init_channels

  delegate :apartment?, :house?, :property?, :to => :top_level_category, :allow_nil => true
  delegate :row_house?, :to => :category, :allow_nil => true
  delegate :coordinates, :to => :address, :allow_nil => true

  scope :reference_projects, :where => { :channels=>REFERENCE_PROJECT_CHANNEL }

  def for_sale?
    self.offer == RealEstate::OFFER_FOR_SALE
  end

  def for_rent?
    self.offer == RealEstate::OFFER_FOR_RENT
  end

  def commercial_utilization?
    self.utilization == RealEstate::UTILIZATION_COMMERICAL
  end

  def private_utilization?
    self.utilization == RealEstate::UTILIZATION_PRIVATE
  end

  def top_level_category
    category.parent
  end


  private
  def init_channels
    self.channels ||= []
  end

end
