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
  STATE_PUBLISHED = 'published'
  STATE_IN_REVIEW = 'in_review'

  REFERENCE_PROJECT_CHANNEL = 'reference_projects'
  WEBSITE_CHANNEL = 'website'
  HOMEGATE_CHANNEL = 'homegate'
  PRINT_CHANNEL = 'print'
  CHANNELS = %W(#{WEBSITE_CHANNEL} #{HOMEGATE_CHANNEL} #{PRINT_CHANNEL} #{REFERENCE_PROJECT_CHANNEL})

  belongs_to :category
  belongs_to :contact, :class_name => 'Employee'
  has_many :appointments

  embeds_one :reference
  embeds_one :address
  embeds_one :pricing, :validate => false
  embeds_one :figure, :validate => false
  embeds_one :information, :validate => false
  embeds_one :infrastructure, :validate => false
  embeds_one :additional_description
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
  validates :utilization, :presence => true
  validates :offer, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true

  after_initialize :init_channels

  delegate :apartment?, :house?, :property?, :to => :top_level_category, :allow_nil => true
  delegate :row_house?, :to => :category, :allow_nil => true
  delegate :coordinates, :to => :address, :allow_nil => true

  scope :reference_projects, :where => { :channels => REFERENCE_PROJECT_CHANNEL }
  scope :published, :where => { :state => STATE_PUBLISHED }
  scope :in_review, :where => { :state => STATE_IN_REVIEW }
  scope :editing, :where => { :state => STATE_EDITING }
  scope :web_channel, :where => {:channels => WEBSITE_CHANNEL}
  scope :recently_updated, lambda { where( :updated_at.gte => 12.hours.ago ) }

  class << self
    extend ActiveSupport::Memoizable

    def mandatory_for_publishing
      metadata = RealEstate.relations.values.select { |r| r.relation == Mongoid::Relations::Embedded::One }
      mandatory_relations = metadata.select { |relation| relation.class_name.constantize.validators.map(&:class).include?(Mongoid::Validations::PresenceValidator) }
      mandatory_relations.map(&:key)
    end

    memoize :mandatory_for_publishing
  end

  state_machine :state, :initial => :editing do

    state :editing

    state :in_review do
      validates *RealEstate.mandatory_for_publishing, :presence=>true,
                :if=>:state_changed?, # Allows admin to save real estate in_review state
                :unless=>:new_record? # ...otherwise the fabricator can't create real estates 'in_review', any idea?
      validates_associated *RealEstate.mandatory_for_publishing,
                           :if=>:state_changed? # Allows admin to save real estate in_review state
    end

    state :published do
      validates *RealEstate.mandatory_for_publishing, :presence=>true,
                :unless=>:new_record? # ...otherwise the fabricator can't create real estates in 'published' state, any idea?
      validates_associated *RealEstate.mandatory_for_publishing
    end

    event :review_it do
      transition :editing => :in_review
    end

    event :reject_it do
      transition :in_review => :editing
    end

    event :publish_it do
      transition [:editing, :in_review] => :published
    end

    event :unpublish_it do
      transition :published => :editing
    end
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
